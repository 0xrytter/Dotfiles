local capabilities = require("lsp.handlers").capabilities

local _lspconfig, lspconfig = pcall(require, "lspconfig")
if _lspconfig then
	-- Python
	lspconfig.pyright.setup({
		autostart = false,
		capabilities = capabilities,
	})

	-- LUA
	lspconfig.lua_ls.setup({
		autostart = false,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		},
	})
	-- Rust
	lspconfig.rust_analyzer.setup({
		on_attach = function(client, bufnr)
			require("lsp.handlers").on_attach(client, bufnr)
			-- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end,
		-- capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					enable = true,
				},
				imports = {
					granularity = {
						group = "module",
					},
					prefix = "self",
				},
				cargo = {
					buildScripts = {
						enable = true,
					},
				},
				procMacro = {
					enable = true,
				},
			},
		},
	})

	-- Elixir
	lspconfig.elixirls.setup({
		cmd = { vim.fn.stdpath("data") .. "/mason/bin/elixir-ls" }, -- Path to ElixirLS
		on_attach = function(client, bufnr)
			require("lsp.handlers").on_attach(client, bufnr)
		end,
		capabilities = capabilities,
		settings = {
			elixirLS = {
				dialyzerEnabled = true,
				fetchDeps = false,
			},
		},
	})

	-- Clangd (C++)
	lspconfig.clangd.setup({})

	-- Bash
	lspconfig.bashls.setup({
		autostart = false,
	})

	-- JavaScript/TypeScript using tsserver
	lspconfig.ts_ls.setup({
		autostart = true,
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			-- Optional: Disable tsserver formatting if using another formatter
			client.server_capabilities.documentFormattingProvider = false

			-- Custom on_attach function if needed
			require("lsp.handlers").on_attach(client, bufnr)
		end,
	})

	-- Svelte language server setup
	lspconfig.svelte.setup({
		autostart = true,
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			require("lsp.handlers").on_attach(client, bufnr)
		end,
	})

	-- Javascript/Typescript
	lspconfig.eslint.setup({
		autostart = true,
		capabilities = capabilities,
		settings = {
			packageManager = "npm",
		},
		on_attach = function(client, bufnr)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				command = "EslintFixAll",
			})
		end,
	})

	lspconfig.tailwindcss.setup({
		cmd = { vim.fn.stdpath("data") .. "/mason/bin/tailwindcss-language-server" },
		capabilities = capabilities,
		filetypes = {
			"html",
			"css",
			"scss",
			"sass",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
			"heex",
			"elixir",
		},
		init_options = {
			userLanguages = {
				elixir = "phoenix-heex",
				heex = "phoenix-heex",
			},
		},
		root_dir = lspconfig.util.root_pattern(
			"tailwind.config.js",
			"assets/tailwind.config.js",
			"package.json",
			".git"
		),
	})

	-- HTML
	lspconfig.html.setup({
		autostart = false,
		capabilities = capabilities,
	})

	-- CSS
	lspconfig.cssls.setup({
		autostart = false,
		capabilities = capabilities,
	})

	-- Dockerfile
	lspconfig.dockerls.setup({
		autostart = false,
		capabilities = capabilities,
	})

	-- Docker compose
	lspconfig.docker_compose_language_service.setup({
		autostart = false,
		capabilities = capabilities,
	})
	-- XML
	lspconfig.lemminx.setup({})

	-- VUE
	lspconfig.vuels.setup({})
end
