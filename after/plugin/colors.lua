function ColorMyPencils(color)
	color= color or "onedark"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal",{bg="none"})  --0 for global space
	vim.api.nvim_set_hl(0, "NormalFloat",{bg="none"})  --0 for global space
end

ColorMyPencils()
