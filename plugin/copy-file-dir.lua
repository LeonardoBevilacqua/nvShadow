local copy_file_dir = function()
	local file_dir = vim.fn.expand("%:p:h")
	local env_variable = "VIM_DIR"
	vim.fn.setenv(env_variable, file_dir)
	print(string.format("$%s set to %s", env_variable, file_dir))
end

vim.api.nvim_create_user_command("CopyFileDir", copy_file_dir, {})
