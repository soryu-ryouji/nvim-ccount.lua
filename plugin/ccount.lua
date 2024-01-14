function get_buffer_text()
	local bufnr = vim.fn.bufnr("%")
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local text = table.concat(lines,'\n')

	return text
end

function get_selected_text()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	
	local start_line = start_pos[2]
	local end_line = end_pos[2]

	local selected_lines = vim.fn.getline(start_line, end_line)

	-- If no content is selected, return directly
	if not selected_lines or #selected_lines == 0 then
		return nil
	end

	if start_line == end_line then
		selected_lines[1] = string.sub(selected_lines[1], start_pos[3], end_pos[4])
	else
		for i, line in ipairs(selected_lines) do
			local start_col = (i == 1) and start_pos[3] or 1
			local end_col = (i == #selected_lines) and end_pos[4] or #line
			if i == #selected_lines then
				-- 对于选中的最后一行，修正 end_col 为字符串末尾位置
				end_col = #line
			end
			selected_lines[i] = string.sub(line, start_col, end_col)
		end
	end
	
	local text = table.concat(selected_lines, '\n')

	return text
end

function count_chinese_characters(str)
  local wordCount = 0
  local charCount = 0

  for word in str:gmatch("%w+") do
    wordCount = wordCount + 1
  end

  for utf8char in str:gmatch("[\226-\233][\128-\191]") do
    charCount = charCount + 1
  end

  local result = wordCount + charCount
  print(result)
end

function count_cc()
	local text = get_selected_text()

	if text then
		count_chinese_characters(text)
	else
		text= get_buffer_text()
		count_chinese_characters(text)
	end
end

vim.api.nvim_command('command! CountCC lua count_cc()')
