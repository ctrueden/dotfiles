require("yafg"):setup {
	editor = os.getenv("EDITOR") or "nvim",
	file_arg_format = "+{row} {file}",
}
