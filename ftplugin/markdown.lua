local utils = require("config.utils")

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path

		if name == "markdown-preview.nvim" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("markdown-preview.nvim")
			end
			--- @type vim.SystemOpts
			local opts = { cwd = path .. "/app", text = true }
			vim.system({ "npm", "install" }, opts, function(obj)
				if obj.code ~= 0 then
					utils.error_message("markdown-preview", "build failed:\n" .. obj.stderr)
				else
					utils.success_message("markdown-preview", "installed")
				end
			end)
		end
	end,
})

vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })
vim.g.mkdp_filetypes = { "markdown" }
