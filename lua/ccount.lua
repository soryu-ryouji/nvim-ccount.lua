function get_buffer_text()
	local bufnr = vim.fn.bufnr("%")
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local text = table.concat(lines,'\n')

	return text
end

function get_selected_text()
	local a_orig = vim.fn.getreg('a')
	local mode = vim.fn.mode()
	if mode ~= 'v' and mode ~= 'V' then
		vim.cmd([[normal! gv]])
	end
	vim.cmd([[silent! normal! "aygv]])
	local text = vim.fn.getreg('a')
	vim.fn.setreg('a', a_orig)

	return text
end

function count_chinese_characters(str)
	local wordCount = 0
	local charCount = 0

	if str ~= nil and str ~= "" then
		-- Iterate over each word in the string
		for word in str:gmatch("%w+") do
			wordCount = wordCount + 1
		end
	end

	if str ~= nil and str ~= "" then
		for utf8char in str:gmatch("[\226-\233][\128-\191]") do
			charCount = charCount + 1
		end
	end

	local result = wordCount + charCount
	print(result)
end

function count_cc()
	local mode = vim.api.nvim_get_mode()["mode"]
	-- print(mode)
	-- print(text)
	if mode == "v" then
		local text = get_selected_text()
		count_chinese_characters(text)
	elseif mode == "n" then
		local text = get_buffer_text()
		count_chinese_characters(text)
	else
		local text = get_buffer_text()
		count_chinese_characters(text)
	end
end

vim.api.nvim_command('command! CountCC lua count_cc()')
