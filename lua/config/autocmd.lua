vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Hightlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Hide line numbers when terminal is open",
	group = vim.api.nvim_create_augroup("term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local keymap = require("config.keymap")

		keymap.map(keymap.normalMode, "gD", vim.lsp.buf.declaration, { desc = "LSP Go to declaration" })
		keymap.map(keymap.normalMode, "gd", vim.lsp.buf.definition, { desc = "LSP Go to definition" })
		keymap.map(keymap.normalMode, "gi", vim.lsp.buf.implementation, { desc = "LSP Go to implementation" })
		keymap.map(keymap.normalMode, "<leader>sh", vim.lsp.buf.signature_help, { desc = "LSP Show signature help" })
		keymap.map(
			keymap.normalMode,
			"<leader>wa",
			vim.lsp.buf.add_workspace_folder,
			{ desc = "LSP Add workspace folder" }
		)
		keymap.map(
			keymap.normalMode,
			"<leader>wr",
			vim.lsp.buf.remove_workspace_folder,
			{ desc = "LSP Remove workspace folder" }
		)

		keymap.map(keymap.normalMode, "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, { desc = "LSP List workspace folders" })

		keymap.map(keymap.normalMode, "<leader>D", vim.lsp.buf.type_definition, { desc = "LSP Go to type definition" })
		keymap.map(keymap.normalMode, "<leader>ra", vim.lsp.buf.rename, { desc = "LSP rename" })

		keymap.map({ keymap.normalMode, "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code action" })
		keymap.map(keymap.normalMode, "gr", vim.lsp.buf.references, { desc = "LSP Show references" })

		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			keymap.map(keymap.normalMode, keymap.leader .. "th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, { desc = "Toggle Inlay hints" })
		end
	end,
})

--vim.api.nvim_create_autocmd("FileType", {
--desc = "Jest commands",
--group = vim.api.nvim_create_augroup("jester-command", { clear = true }),
--pattern = { "typescript", "javascript" },
--callback = function()
--local keymap = require("config.keymap")
--local jester = require("jester")
--
--keymap.map(keymap.normalMode, keymap.leader .. "tc", jester.run, { desc = "JEST test current" })
--keymap.map(keymap.normalMode, keymap.leader .. "tf", jester.run_file, { desc = "JEST test file" })
--keymap.map(keymap.normalMode, keymap.leader .. "Tc", jester.debug, { desc = "JEST test debug current" })
--keymap.map(keymap.normalMode, keymap.leader .. "Tc", jester.debug_file, { desc = "JEST test debug file" })
--end,
--})
