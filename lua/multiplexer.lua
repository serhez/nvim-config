-- Terminal multiplexer abstraction over herdr and tmux.
--
-- Herdr injects its *server's* environment into every managed pane, so a herdr
-- pane whose server happened to be started from inside tmux still carries TMUX,
-- TMUX_PANE and TERM_PROGRAM=tmux. Those describe an unrelated tmux session, so
-- HERDR_ENV has to be checked first and win: `vim.env.TMUX ~= nil` alone is not
-- evidence that this Neovim is usefully inside tmux.

local M = {}

---@alias MultiplexerKind "herdr"|"tmux"|nil

---@return MultiplexerKind
function M.kind()
	if vim.env.HERDR_ENV == "1" then
		return "herdr"
	end
	if vim.env.TMUX ~= nil and vim.env.TMUX ~= "" then
		return "tmux"
	end
	return nil
end

---Path to the herdr binary, preferring the one that spawned this pane.
---@return string
function M.herdr_bin()
	local bin = vim.env.HERDR_BIN_PATH
	if bin == nil or bin == "" then
		return "herdr"
	end
	return bin
end

---Run a herdr CLI command and return its decoded `result`, or nil on failure.
---@param args string[]
---@return table?
function M.herdr_api(args)
	local cmd = { M.herdr_bin() }
	vim.list_extend(cmd, args)

	local out = vim.system(cmd, { text = true }):wait()
	if out.code ~= 0 then
		return nil
	end

	local ok, decoded = pcall(vim.json.decode, out.stdout)
	if not ok or type(decoded) ~= "table" then
		return nil
	end
	return decoded.result
end

local function find_by(list, key, value)
	for _, item in ipairs(list or {}) do
		if item[key] == value then
			return item
		end
	end
	return nil
end

local function label_of(item)
	if type(item) == "table" and type(item.label) == "string" and item.label ~= "" then
		return item.label
	end
	return nil
end

-- "<workspace>:<tab>", the herdr counterpart of tmux's "<session>:<window>".
--
-- Labels rather than IDs, so that renaming a tab forks its session while moving
-- panes around leaves it alone. If the server cannot be reached we fall back to
-- the IDs from the environment: opaque, but still unique per tab. An empty tag
-- would be far worse, collapsing every workspace into one shared session.
local function herdr_tag()
	local workspace_id = vim.env.HERDR_WORKSPACE_ID or ""
	local tab_id = vim.env.HERDR_TAB_ID or ""

	local workspaces = M.herdr_api({ "workspace", "list" })
	local workspace = label_of(workspaces and find_by(workspaces.workspaces, "workspace_id", workspace_id))

	local tabs = workspace and M.herdr_api({ "tab", "list", "--workspace", workspace_id })
	local tab = label_of(tabs and find_by(tabs.tabs, "tab_id", tab_id))

	if workspace == nil or tab == nil then
		return workspace_id .. ":" .. tab_id
	end
	return workspace .. ":" .. tab
end

local function tmux_display(format)
	local out = vim.system({ "tmux", "display-message", "-p", format }, { text = true }):wait()
	if out.code ~= 0 then
		return nil
	end
	local value = vim.trim(out.stdout or "")
	return value ~= "" and value or nil
end

-- NOTE: The window index ("#I") is deliberately left out, here and in the herdr
--       tag, so windows can be rearranged without changing their session. To
--       give a window its own session, give it its own name.
local function tmux_tag()
	return (tmux_display("#S") or "__session__") .. ":" .. (tmux_display("#W") or "__window__")
end

---Identifier of the multiplexer pane this Neovim runs in, "" when there is none.
---@return string
function M.session_tag()
	local kind = M.kind()
	if kind == "herdr" then
		return herdr_tag()
	elseif kind == "tmux" then
		return tmux_tag()
	end
	return ""
end

---@param argv string[]
---@param opts { direction: "right"|"down", ratio: number? }
local function herdr_split(argv, opts)
	local cmd = {
		"pane",
		"split",
		"--current",
		"--direction",
		opts.direction,
		"--cwd",
		vim.uv.cwd(),
		"--no-focus",
	}
	if opts.ratio then
		vim.list_extend(cmd, { "--ratio", tostring(opts.ratio) })
	end

	local result = M.herdr_api(cmd)
	local pane_id = result and result.pane and result.pane.pane_id
	if pane_id == nil then
		return false, "herdr pane split failed"
	end

	-- Unlike `tmux split-window`, herdr splits into a plain shell and `pane run`
	-- types the command at its prompt, so give that shell a moment to get there;
	-- anything sent before the prompt is dropped.
	local command = table.concat(vim.tbl_map(vim.fn.shellescape, argv), " ")
	vim.defer_fn(function()
		M.herdr_api({ "pane", "run", pane_id, command })
	end, 300)

	return true
end

---@param argv string[]
---@param opts { direction: "right"|"down", ratio: number? }
local function tmux_split(argv, opts)
	local cmd = { "tmux", "split-window", opts.direction == "down" and "-v" or "-h" }
	if opts.ratio then
		vim.list_extend(cmd, { "-p", tostring(math.floor(opts.ratio * 100)) })
	end
	vim.list_extend(cmd, argv)

	local out = vim.system(cmd, { text = true }):wait()
	if out.code ~= 0 then
		return false, vim.trim(out.stderr or "") ~= "" and vim.trim(out.stderr) or "tmux split-window failed"
	end
	return true
end

---Open a command in a new multiplexer pane beside this one, without taking focus.
---@param argv string[] command and its arguments
---@param opts? { direction?: "right"|"down", ratio?: number } ratio is a fraction of the current pane
---@return boolean ok, string? err
function M.open_in_split(argv, opts)
	opts = {
		direction = opts and opts.direction or "right",
		ratio = opts and opts.ratio or nil,
	}

	local kind = M.kind()
	if kind == "herdr" then
		return herdr_split(argv, opts)
	elseif kind == "tmux" then
		return tmux_split(argv, opts)
	end
	return false, "not running inside herdr or tmux"
end

return M
