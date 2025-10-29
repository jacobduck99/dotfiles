return {
  {
    -- Apply highlight overrides after theme is loaded
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1b26" })
          vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7aa2f7", bg = "#1a1b26" })
        end,
      })
    end,
  },
}

