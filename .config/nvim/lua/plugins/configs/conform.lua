return {
	"stevearc/conform.nvim",
	opts = {
		formatters = {
			xmllint = {
				command = "xmllint",
				args = { "--format", "-" },
				stdin = true,
			},
			tidy = {
				command = "tidy",
				args = { "--tidy-mark", "no", "-quiet", "-indent", "-wrap", "0" },
				stdin = true,
			},
			credo = {
				command = "mix",
				args = { "credo", "suggest", "--format=flycheck", "--read-from-stdin" },
				stdin = true,
			},
			mix_format = {
				command = "mix",
				args = { "format" },
				stdin = true,
			},
		},

		formatters_by_ft = {
			lua = { "stylua" },
			json = { "jq" },
			html = { "prettierd", "prettier", "tidy" }, -- Removed nested {}
			css = { "prettierd", "prettier", "tidy" }, -- Removed nested {}
			xhtml = { "xmllint", "tidy" },
			xml = { "xmllint" },
			xsd = { "xmllint" },
			javascript = { "prettierd", "prettier" }, -- Removed nested {}
			elixir = { "lsp" }, -- Use LSP formatter for Elixir
			heex = { "lsp" }, -- Use LSP formatter for HEEx files
		},

		format_on_save = {
			lsp_format = true, -- Enable LSP formatting on save
			timeout_ms = 2000, -- Increase timeout if necessary
		},

		stop_after_first = true, -- Optional: Stop after the first successful formatter
	},
}
