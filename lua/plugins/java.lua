return {
	"mfussenegger/nvim-jdtls",
	ft = { "java" },
	config = function()
		local mason_registry = require("mason-registry")
		local jdtls = mason_registry.get_package("jdtls")
		local jdtls_path = jdtls:get_install_path()
		local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
		local SYSTEM = "win"
		local os_config = jdtls_path .. "/config_" .. SYSTEM

		local home = os.getenv("HOME")
		local workspace_path = home .. "/code/workspace/"
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		local workspace_dir = workspace_path .. project_name

		local config = {
			cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				launcher,
				"-configuration",
				os_config,
				"-data",
				workspace_dir,
			},
			root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
		}

		require("jdtls").start_or_attach(config)
	end,
}
