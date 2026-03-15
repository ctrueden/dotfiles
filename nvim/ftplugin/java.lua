-- ftplugin/java.lua
-- Runs every time a Java buffer is opened.
-- nvim-jdtls manages the LSP connection instead of lspconfig,
-- enabling Java-specific extensions (debug, test runner, refactoring).

local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
	return
end

-- ── Paths ────────────────────────────────────────────────────────────────────

local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
local jdtls_dir = mason_packages .. "/jdtls"

if vim.fn.isdirectory(jdtls_dir) == 0 then
	vim.notify("jdtls not found in Mason packages; run :MasonInstall jdtls", vim.log.levels.WARN)
	return
end

local os_config = "config_linux"
if vim.fn.has("mac") == 1 then
	os_config = vim.fn.has("arm64") == 1 and "config_mac_arm" or "config_mac"
elseif vim.fn.has("win32") == 1 then
	os_config = "config_win"
end

-- Per-project workspace dir so each project gets its own jdtls index.
local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- ── Bundles (debug + test) ────────────────────────────────────────────────────

local bundles = {}

local debug_jar =
	vim.fn.glob(mason_packages .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
if debug_jar ~= "" then
	table.insert(bundles, debug_jar)
end

local test_jars = vim.fn.glob(mason_packages .. "/java-test/extension/server/*.jar", false, true)
vim.list_extend(bundles, test_jars)

-- ── Capabilities ─────────────────────────────────────────────────────────────

local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then
	capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
end

-- ── on_attach ────────────────────────────────────────────────────────────────

local function on_attach(_, bufnr)
	-- Wire up debug + test extensions
	jdtls.setup_dap({ hotcodereplace = "auto" })
	jdtls.setup.add_commands()
	-- Discover main classes and populate DAP configs so <F5> can run/debug them.
	-- This is async: jdtls must finish indexing before configs appear.
	require("jdtls.dap").setup_dap_main_class_configs()

	local map = function(key, fn, desc)
		vim.keymap.set("n", key, fn, { buffer = bufnr, desc = "Java: " .. desc })
	end

	-- Refactoring
	map("<leader>jo", jdtls.organize_imports, "Organize imports")
	map("<leader>jv", jdtls.extract_variable, "Extract variable")
	map("<leader>jc", jdtls.extract_constant, "Extract constant")
	map("<leader>jm", jdtls.extract_method, "Extract method")

	-- Tests (requires java-test bundle)
	map("<leader>jt", jdtls.test_nearest_method, "Run nearest test")
	map("<leader>jT", jdtls.test_class, "Run class tests")

	-- Re-discover main classes (e.g. after adding a new main method)
	map("<leader>jd", require("jdtls.dap").setup_dap_main_class_configs, "Discover main classes")

	-- Visual-mode refactoring
	local vmap = function(key, fn, desc)
		vim.keymap.set("v", key, fn, { buffer = bufnr, desc = "Java: " .. desc })
	end
	vmap("<leader>jv", function()
		jdtls.extract_variable(true)
	end, "Extract variable")
	vmap("<leader>jm", function()
		jdtls.extract_method(true)
	end, "Extract method")
end

-- ── Config ───────────────────────────────────────────────────────────────────

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
		vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		jdtls_dir .. "/" .. os_config,
		"-data",
		workspace_dir,
	},
	root_dir = root_dir,
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" }, -- decompile jars on grd
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.mockito.Mockito.*",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
		},
	},
	init_options = {
		bundles = bundles,
	},
}

jdtls.start_or_attach(config)
