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
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
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

return M
