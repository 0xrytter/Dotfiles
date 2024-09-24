return {
    "zapling/mason-conform.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "stevearc/conform.nvim",
    },
    config = function()
        require("mason-conform").setup({
            ensure_installed = { "prettierd", "stylua", "jq", "xmllint", "tidy" }, -- Add other formatters as needed
        })
    end,
}
