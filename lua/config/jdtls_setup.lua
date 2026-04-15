local M = {}

local bundle = {
	vim.fn.glob(
		vim.fn.stdpath("data")
			.. package.config:sub(1, 1)
			.. "mason"
			.. package.config:sub(1, 1)
			.. "packages"
			.. package.config:sub(1, 1)
			.. "java-debug-adapter"
			.. package.config:sub(1, 1)
			.. "extension"
			.. package.config:sub(1, 1)
			.. "server"
			.. package.config:sub(1, 1)
			.. "com.microsoft.java.debug.plugin-*.jar",
		true
	),
}

function M.setup()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = vim.fn.stdpath("data")
		.. package.config:sub(1, 1)
		.. "jdtls-workspace"
		.. package.config:sub(1, 1)
		.. project_name
	local os_name = require('config.utils').is_windows() and "win" or "linux"
	local config = {
		-- The command that starts the language server
		-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
		cmd = {

			-- 💀
			"java", -- or '/path/to/java17_or_newer/bin/java'
			-- depends on if `java` is in your $PATH env variable and if it points to the right version.

			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=WARN",
			"-javaagent:"
				.. vim.fn.stdpath("data")
				.. package.config:sub(1, 1)
				.. "mason"
				.. package.config:sub(1, 1)
				.. "packages"
				.. package.config:sub(1, 1)
				.. "jdtls"
				.. package.config:sub(1, 1)
				.. "lombok.jar",
			"-Xmx1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",

			-- 💀
			"-jar",
			vim.fn.stdpath("data")
				.. package.config:sub(1, 1)
				.. "mason"
				.. package.config:sub(1, 1)
				.. "packages"
				.. package.config:sub(1, 1)
				.. "jdtls"
				.. package.config:sub(1, 1)
				.. "plugins"
				.. package.config:sub(1, 1)
				.. "org.eclipse.equinox.launcher_1.7.100.v20251111-0406.jar",
			-- 💀
			"-configuration",
			vim.fn.stdpath("data")
				.. package.config:sub(1, 1)
				.. "mason"
				.. package.config:sub(1, 1)
				.. "packages"
				.. package.config:sub(1, 1)
				.. "jdtls"
				.. package.config:sub(1, 1)
				.. "config_"
				.. os_name,
			-- 💀
			-- See `data directory configuration` section in the README
			"-data",
			workspace_dir,
		},

		-- 💀
		-- This is the default if not provided, you can remove it. Or adjust as needed.
		-- One dedicated LSP server & client will be started per unique root_dir
		root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

		-- Here you can configure eclipse.jdt.ls specific settings
		-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
		-- for a list of options
		settings = {
			java = {
                configuration = {
                    updateBuildConfiguration = "automatic",
                },
                completion = {
                    importOrder = {
                        "#",
                        "java",
                        "javax",
                        "com.lenovo",
                    },
                },
                format = {
                    enabled = true,
                    settings = {
                        url = vim.fn.stdpath("config")
                            .. package.config:sub(1, 1)
                            .. "formatter"
                            .. package.config:sub(1, 1)
                            .. "eclipse-formatter.xml",
                        profile = "Checkstyle",
                    },
                    comments = { enabled = true },
                },
                sources = {
                    organizeImports = {
                        staticStarThreshold = 999,
                        starThreshold = 999,
                        staticImportsOrder = "before"
                    },
                },
            },
		},

		-- Language server `initializationOptions`
		-- You need to extend the `bundles` with paths to jar files
		-- if you want to use additional eclipse.jdt.ls plugins.
		--
		-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
		--
		-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
		init_options = {
			bundles = bundle,
		},
        on_attach = function ()
            vim.opt.shiftwidth = 2
            vim.opt.tabstop = 2
            vim.opt.softtabstop = 2
            local keymap = require("config.keymap")
            keymap.map(keymap.normalMode, keymap.leader .. "fM", function()
                vim.lsp.buf.code_action({
                    filter = function(action)
                        return action.kind == "source.organizeImports"
                    end,
                    apply = true,
                })
            end, { desc = "general format imports" })
        end
	}
	-- This starts a new client & server,
	-- or attaches to an existing client & server depending on the `root_dir`.
	require("jdtls").start_or_attach(config)

	-- configure key binds
	local keymap = require("config.keymap")
	-- Normal mode
    -- Check if version from line 147 is better or the same, if same, remove the other
	-- keymap.map(keymap.normalMode, keymap.leader .. "fM", function()
	-- 	require("jdtls").organize_imports()
	-- end, { desc = "general format imports" })

	keymap.map(keymap.normalMode, keymap.leader .. "crv", function()
		require("jdtls").extract_variable()
	end, { desc = "Extract variable" })

	keymap.map(keymap.normalMode, keymap.leader .. "crc", function()
		require("jdtls").extract_constant()
	end, { desc = "Extract constant" })

	-- Visual mode
	keymap.map(keymap.visualMode, keymap.leader .. "crv", function()
		require("jdtls").extract_variable(true)
	end, { desc = "Extract variable" })

	keymap.map(keymap.visualMode, keymap.leader .. "crc", function()
		require("jdtls").extract_constant(true)
	end, { desc = "Extract constant" })

	keymap.map(keymap.visualMode, keymap.leader .. "crm", function()
		require("jdtls").extract_method(true)
	end, { desc = "Extract method" })
end

return M
