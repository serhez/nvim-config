local multiplexer = require("multiplexer")

local M = {}

M.config = {
	size_limit = 2 * 1024 * 1024, -- 2MB in bytes
	split_direction = "right", -- "right" or "down"
	split_ratio = nil, -- fraction of the current pane, e.g. 0.5. nil = multiplexer default
	mode = "nvim", -- "nvim" for editing, "less" for fast read-only viewing
}

local function get_file_size(path)
	local stat = vim.uv.fs_stat(path)
	return stat and stat.size or 0
end

local function open_in_split(filepath)
	local argv
	if M.config.mode == "less" then
		argv = { "less", filepath }
	else
		argv = {
			"nvim",
			"-n",
			"-i",
			"NONE",
			"--noplugin",
			"-u",
			vim.fn.stdpath("config") .. "/minimal.lua",
			"--cmd",
			"set noloadplugins",
			filepath,
		}
	end

	return multiplexer.open_in_split(argv, {
		direction = M.config.split_direction,
		ratio = M.config.split_ratio,
	})
end

local function format_size(bytes)
	if bytes >= 1024 * 1024 then
		return string.format("%.1f MB", bytes / (1024 * 1024))
	elseif bytes >= 1024 then
		return string.format("%.1f KB", bytes / 1024)
	else
		return string.format("%d bytes", bytes)
	end
end

-- Track big file buffers
local bigfile_bufs = {}

function M.setup(opts)
	opts = opts or {}
	M.config = vim.tbl_deep_extend("force", M.config, opts)

	local augroup = vim.api.nvim_create_augroup("bigfile", { clear = true })

	-- Detect big files BEFORE reading
	vim.api.nvim_create_autocmd("BufReadPre", {
		group = augroup,
		callback = function(args)
			local path = args.match

			-- Skip special protocols
			if path:match("://") or path == "" then
				return
			end

			local resolved = vim.fn.resolve(path)
			if vim.fn.filereadable(resolved) == 0 then
				return
			end

			local size = get_file_size(resolved)
			if size <= M.config.size_limit then
				return
			end

			-- Mark this buffer as a big file
			bigfile_bufs[args.buf] = {
				path = resolved,
				size = size,
			}

			-- Prevent the file from being read by making it a special buffer
			vim.bo[args.buf].buftype = "nofile"
			vim.bo[args.buf].swapfile = false
			vim.bo[args.buf].undolevels = -1
		end,
	})

	-- Handle big files AFTER the (prevented) read
	vim.api.nvim_create_autocmd("BufReadPost", {
		group = augroup,
		callback = function(args)
			local info = bigfile_bufs[args.buf]
			if not info then
				return
			end
			bigfile_bufs[args.buf] = nil

			local size_str = format_size(info.size)

			-- Set up the buffer
			vim.bo[args.buf].bufhidden = "wipe"
			vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, { "Big file - opening in a new pane..." })
			vim.bo[args.buf].modifiable = false

			local mode_desc = M.config.mode == "less" and "less (read-only)" or "minimal nvim"
			if multiplexer.kind() == nil then
				vim.notify(
					string.format(
						"Big file (%s) blocked. Run in herdr or tmux, or use: nvim -u minimal.lua %s",
						size_str,
						vim.fn.shellescape(info.path)
					),
					vim.log.levels.ERROR
				)
			else
				local ok, err = open_in_split(info.path)
				if ok then
					vim.notify(
						string.format("Big file (%s) opened in a new pane with %s", size_str, mode_desc),
						vim.log.levels.INFO
					)
				else
					vim.notify(string.format("Failed to open pane: %s", tostring(err)), vim.log.levels.ERROR)
				end
			end

			-- Go back to previous buffer and wipe this one
			vim.schedule(function()
				pcall(vim.cmd, "bprevious")
				pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
			end)
		end,
	})
end

return M
