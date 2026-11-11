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

-- ── Java runtime for jdtls ───────────────────────────────────────────────────

-- Note: jdtls runs on its own JDK, deliberately independent of JAVA_HOME,
-- because its minimum Java version rises with jdtls releases. The minimum is
-- detected from the bundle manifests and cached per jdtls version, along with
-- a matching local JDK. Projects still compile against their own target level.

local function java_major(version)
	local a, b = version:gsub("^%a+%-", ""):match("^(%d+)%.?(%d*)")
	a = tonumber(a)
	if a == 1 then
		return tonumber(b) -- e.g. 1.8.0_452
	end
	return a
end

local function jdtls_version()
	local ok, receipt = pcall(function()
		return vim.json.decode(table.concat(vim.fn.readfile(jdtls_dir .. "/mason-receipt.json"), "\n"))
	end)
	return ok and receipt.source and receipt.source.id or "unknown"
end

local function min_java_for_jdtls()
	local script = [[
for f in "$1"/*.jar; do unzip -p "$f" META-INF/MANIFEST.MF 2>/dev/null; done |
	tr -d '\r\n ' | grep -o 'osgi.ee=JavaSE)(version=[0-9.]*'
]]
	local out = vim.system({ "sh", "-c", script, "sh", jdtls_dir .. "/plugins" }):wait().stdout or ""
	local min = nil
	for version in out:gmatch("version=([%d.]+)") do
		local major = java_major(version)
		if major and (not min or major > min) then
			min = major
		end
	end
	-- Note: 21 is the floor documented by jdtls itself, should the scan fail.
	return min or 21
end

-- Note: An exact major version match, not merely a minimum, because the JDK
-- running jdtls is also the default system library for projects; newer majors
-- drop APIs that older-target projects may still use.
local function find_local_jdk(major)
	local jhome = vim.fn.exepath("jhome")
	if jhome == "" then
		local here = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
		jhome = vim.fn.resolve(here .. "/../../bin/java/jhome")
	end
	if vim.fn.executable(jhome) == 0 then
		return nil
	end
	local home = vim.trim(vim.system({ jhome, ("^%d([.]|$)"):format(major) }):wait().stdout or "")
	return home ~= "" and home or nil
end

local function jdtls_java()
	local cache_file = vim.fn.stdpath("cache") .. "/jdtls-java.json"
	local ok, cache = pcall(function()
		return vim.json.decode(table.concat(vim.fn.readfile(cache_file), "\n"))
	end)
	if not ok or type(cache) ~= "table" then
		cache = {}
	end
	local changed = false

	local version = jdtls_version()
	if cache.jdtls ~= version then
		cache.jdtls, cache.min_java = version, min_java_for_jdtls()
		changed = true
	end

	local valid = cache.java_home
		and vim.fn.executable(cache.java_home .. "/bin/java") == 1
		and cache.java_major == cache.min_java
	if not valid then
		cache.java_home = find_local_jdk(cache.min_java)
		cache.java_major = cache.java_home and cache.min_java
		changed = true
	end

	if changed then
		vim.fn.mkdir(vim.fn.fnamemodify(cache_file, ":h"), "p")
		vim.fn.writefile({ vim.json.encode(cache) }, cache_file)
	end

	if not cache.java_home then
		local msg = ("jdtls %s needs Java %d, but no such JDK was found locally (see jlist).\n"
			.. "Install one, e.g. `cjdk --jdk zulu:%d java-home`, then reopen this file."):format(
			version:match("@(.+)$") or version,
			cache.min_java,
			cache.min_java
		)
		-- Note: Deferred, because an error-level notify inside an ftplugin is
		-- raised as an exception, burying the message in an autocmd traceback.
		vim.schedule(function()
			vim.notify(msg, vim.log.levels.ERROR)
		end)
		return nil
	end
	return cache.java_home .. "/bin/java"
end

local java_bin = jdtls_java()
if not java_bin then
	return
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

	-- Run/debug a main class (same as kickstart's <F5>). Note: grx is Neovim's
	-- default "run code lens" key, but jdtls emits no run/debug lenses (those
	-- are client-side in VS Code), so we reuse the key for the same intent.
	map("grx", require("dap").continue, "Run/debug main class")

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
		java_bin,
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
