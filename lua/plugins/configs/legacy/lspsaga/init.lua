require("lspsaga").setup({
	use_saga_diagnostic_sign = false,
	code_action_prompt = {
		enable = true,
		sign = false,
		sign_priority = 40,
		virtual_text = false,
	},
	rename_action_keys = {
		quit = "<Esc>",
		exec = "<cr>",
	},
	border_style = "single",
	rename_output_qflist = {
		enable = false,
		auto_open_qflist = false,
	},
})
