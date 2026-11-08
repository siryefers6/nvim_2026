-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Python
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"

-- Editor
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ""
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 5

-- Ventanas
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Transparencia del menú de autocompletado
vim.opt.pumblend = 10

-- Mantener el portapapeles interno de Neovim
vim.opt.clipboard = ""

-- Copiar automáticamente los textos seleccionados con y
-- al portapapeles externo mediante OSC 52
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" then
      require("vim.ui.clipboard.osc52").copy("+")(vim.v.event.regcontents, vim.v.event.regtype)
    end
  end,
})
