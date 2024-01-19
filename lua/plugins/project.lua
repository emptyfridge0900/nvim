return {
  "ahmedkhalf/project.nvim",
  config = function()
    pcall(require('telescope').load_extension, 'projects')
    require("project_nvim").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "*.sln" },

    }
  end
}