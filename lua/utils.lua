local M = {}

function M.concat_tables(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

function M.define_augroups(definitions) -- {{{
	-- Create autocommand groups based on the passed definitions
	--
	-- The key will be the name of the group, and each definition
	-- within the group should have:
	--    1. Trigger
	--    2. Pattern
	--    3. Text
	-- just like how they would normally be defined from Vim itself
	for group_name, definition in pairs(definitions) do
		vim.cmd("augroup " .. group_name)
		vim.cmd("autocmd!")

		for _, def in pairs(definition) do
			local command = table.concat(vim.iter({ "autocmd", def }):flatten():totable(), " ")
			vim.cmd(command)
		end

		vim.cmd("augroup END")
	end
end

function M.split_path(path)
	local components = {}
	for component in path:gmatch("[^/]+") do
		table.insert(components, component)
	end
	return components
end

-- TODO: Improve, this is garbage
function M.truncate_path(path, width)
	local components = M.split_path(path)
	local truncated = {}
	local total_length = 0
	for i = #components, 1, -1 do
		local component = components[i]
		if total_length + #component + 1 > width then
			break
		end
		table.insert(truncated, 1, component)
		total_length = total_length + #component + 1
	end
	if #truncated == #components then
		return path
	end
	return table.concat(truncated, "/")
end

function M.statusline_escape(value)
	local escaped = tostring(value or ""):gsub("%%", "%%%%")
	return escaped
end

local function normalize_local_path(path)
	if not path or path == "" then
		return nil
	end

	local expanded = vim.fn.expand(path)
	local normalized = vim.fn.fnamemodify(expanded, ":p")
	return normalized:gsub("/+$", "")
end

local function path_is_inside(path, root)
	path = normalize_local_path(path)
	root = normalize_local_path(root)
	if not path or not root then
		return false
	end

	return path == root or vim.startswith(path, root .. "/")
end

function M.parse_canola_ssh_url(url)
	local scheme = tostring(url or ""):match("^([%w%+%-%.]+://)")
	if scheme ~= "canola-ssh://" then
		return nil
	end

	return M.parse_remote_ssh_url(url)
end

function M.parse_remote_ssh_url(url)
	local scheme, remote = tostring(url or ""):match("^([%w%+%-%.]+://)(.+)$")
	local remote_schemes = {
		["canola-ssh://"] = true,
		["oil-ssh://"] = true,
		["scp://"] = true,
		["ssh://"] = true,
	}
	if not remote_schemes[scheme] then
		return nil
	end

	local machine, path = remote:match("^([^/]+)(/.*)$")
	if not machine then
		return nil
	end

	path = path:gsub("^//", "/")
	if path == "" then
		path = "/"
	elseif path:sub(1, 1) ~= "/" then
		path = "/" .. path
	end

	return machine, path
end

function M.is_remote_ssh_url(path)
	return M.parse_remote_ssh_url(path) ~= nil
end

function M.slow_fs_roots()
	local roots = {}
	local seen = {}

	local configured_roots = vim.g.slow_fs_roots or { vim.g.sshfs_mount_root or "~/mnt" }
	if type(configured_roots) == "string" then
		configured_roots = { configured_roots }
	end

	for _, root in ipairs(configured_roots) do
		local normalized = normalize_local_path(root)
		if normalized and not seen[normalized] then
			table.insert(roots, normalized)
			seen[normalized] = true
		end
	end

	return roots
end

function M.is_slow_fs_path(path)
	if vim.g.slow_network then
		return true
	end

	if not path or path == "" then
		return false
	end

	if M.is_remote_ssh_url(path) then
		return true
	end

	if tostring(path):match("^%w[%w+%-%.]*://") then
		return false
	end

	for _, root in ipairs(M.slow_fs_roots()) do
		if path_is_inside(path, root) then
			return true
		end
	end

	return false
end

function M.is_slow_fs_buf(bufnr)
	bufnr = bufnr or 0
	if vim.b[bufnr].slow_fs then
		return true
	end
	return M.is_slow_fs_path(vim.api.nvim_buf_get_name(bufnr))
end

local remote_home_cache = {}
local remote_home_pending = {}
local remote_home_failed_at = {}
local remote_home_retry_ms = 30000

local function trim(value)
	return tostring(value or ""):match("^%s*(.-)%s*$")
end

local function normalize_home_path(home)
	home = trim(home)
	if home ~= "/" then
		home = home:gsub("/+$", "")
	end
	return home
end

local function extract_remote_homes(output)
	local homes = {}
	local seen = {}
	for line in tostring(output or ""):gmatch("[^\r\n]+") do
		line = trim(line)
		if line:match("^/") then
			local home = normalize_home_path(line)
			if home ~= "" and not seen[home] then
				table.insert(homes, home)
				seen[home] = true
			end
		end
	end
	table.sort(homes, function(a, b)
		return #a > #b
	end)
	return homes
end

local function ssh_home_command(machine)
	local target = machine
	local port
	local host_without_port, parsed_port = machine:match("^(.-):(%d+)$")
	if host_without_port and host_without_port ~= "" then
		target = host_without_port
		port = parsed_port
	end

	local cmd = {
		"ssh",
		"-o",
		"BatchMode=yes",
		"-o",
		"ConnectTimeout=2",
	}

	if port then
		table.insert(cmd, "-p")
		table.insert(cmd, port)
	end

	table.insert(cmd, target)
	table.insert(cmd, 'home=$HOME; printf "%s\\n" "$home"; cd "$home" 2>/dev/null && pwd -P')
	return cmd
end

local function refresh_statusline()
	vim.schedule(function()
		pcall(vim.cmd, "redrawstatus")
	end)
end

local function get_upvalue(fn, upvalue_name)
	for index = 1, math.huge do
		local name, value = debug.getupvalue(fn, index)
		if not name then
			return nil
		end
		if name == upvalue_name then
			return value
		end
	end
end

local function existing_canola_ssh_connection(machine)
	if type(debug) ~= "table" or type(debug.getupvalue) ~= "function" then
		return nil
	end

	local ok, ssh_adapter = pcall(require, "canola.adapters.ssh")
	if not ok or type(ssh_adapter.open_terminal) ~= "function" then
		return nil
	end

	local get_connection = get_upvalue(ssh_adapter.open_terminal, "get_connection")
	if type(get_connection) ~= "function" then
		return nil
	end

	local connections = get_upvalue(get_connection, "_connections")
	if type(connections) ~= "table" then
		return nil
	end

	return connections["canola-ssh://" .. machine .. "/"]
end

local function cache_remote_homes(machine, homes)
	if type(homes) == "string" then
		homes = { normalize_home_path(homes) }
	end

	if type(homes) == "table" and #homes > 0 then
		remote_home_cache[machine] = homes
		remote_home_failed_at[machine] = nil
		refresh_statusline()
		return true
	end

	remote_home_failed_at[machine] = vim.uv.now()
	return false
end

local function fetch_remote_home_with_canola(machine, callback)
	local connection = existing_canola_ssh_connection(machine)
	if not connection or connection.connection_error then
		return false
	end

	local runner = type(connection.run) == "function" and connection or connection.conn
	if not runner or type(runner.run) ~= "function" or runner.connection_error then
		return false
	end

	runner:run('home=$HOME; printf "%s\\n" "$home"; cd "$home" 2>/dev/null && pwd -P', function(err, lines)
		if err then
			callback(nil)
			return
		end
		callback(extract_remote_homes(table.concat(lines or {}, "\n")))
	end)
	return true
end

local function fetch_remote_home_with_ssh(machine, callback)
	vim.system(ssh_home_command(machine), { text = true }, function(result)
		if result.code == 0 then
			callback(extract_remote_homes(result.stdout))
		else
			callback(nil)
		end
	end)
end

function M.remote_homes_for_machine(machine)
	local cached = remote_home_cache[machine]
	if cached ~= nil then
		return cached
	end

	if remote_home_pending[machine] then
		return nil
	end

	local function on_homes(homes)
		remote_home_pending[machine] = nil
		cache_remote_homes(machine, homes)
	end

	remote_home_pending[machine] = true
	if fetch_remote_home_with_canola(machine, on_homes) then
		return nil
	end
	remote_home_pending[machine] = nil

	if not vim.system then
		return nil
	end

	local last_failure = remote_home_failed_at[machine]
	if last_failure and vim.uv.now() - last_failure < remote_home_retry_ms then
		return nil
	end

	remote_home_pending[machine] = true
	fetch_remote_home_with_ssh(machine, on_homes)
	return nil
end

function M.remote_home_for_machine(machine)
	local homes = M.remote_homes_for_machine(machine)
	if type(homes) == "table" then
		return homes[1]
	end
	return homes
end

function M.remote_path_for_display(machine, path)
	local homes = M.remote_homes_for_machine(machine)
	if type(homes) == "string" then
		homes = { homes }
	end
	if type(homes) ~= "table" then
		return path
	end

	for _, home in ipairs(homes) do
		if home ~= "/" then
			if path == home then
				return "~"
			end

			if vim.startswith(path, home .. "/") then
				return "~" .. path:sub(#home + 1)
			end
		end
	end

	return path
end

local function ssh_location_from_parts(machine, path)
	if not machine then
		return nil
	end

	return machine, M.remote_path_for_display(machine, path)
end

function M.remote_ssh_location(url)
	return ssh_location_from_parts(M.parse_remote_ssh_url(url))
end

function M.canola_ssh_location(url)
	return ssh_location_from_parts(M.parse_canola_ssh_url(url))
end

function M.canola_statusline_location(url, host_highlight)
	local machine, path = M.canola_ssh_location(url)
	if not machine then
		return nil
	end

	return table.concat({
		"%#",
		host_highlight,
		"#",
		M.statusline_escape(machine),
		"%*: ",
		M.statusline_escape(path),
	})
end

return M
