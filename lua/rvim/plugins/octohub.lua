local pickme_ok, pickme = pcall(require, "pickme")
if pickme_ok then
	pickme.setup({
		picker_provider = "snacks",
		detect_provider = true,
		add_default_keybindings = false,
	})
end

local octohub_ok, octohub = pcall(require, "octohub")
if not octohub_ok then
	return
end

octohub.setup({
	repos = {
		per_user_dir = true,
		projects_dir = "~/Projects/",
		sort_by = "",
		repo_type = "",
	},
	stats = {
		contribution_icons = { "", "", "", "", "", "", "" },
		max_contributions = 50,
		top_lang_count = 5,
		event_count = 5,
		window_width = 90,
		window_height = 60,
		show_recent_activity = true,
		show_contributions = true,
		show_repo_stats = true,
	},
	cache = {
		events = 3600 * 6,
		contributions = 3600 * 6,
		repos = 3600 * 24 * 7,
		username = 3600 * 24 * 7,
		user = 3600 * 24 * 7,
	},
	add_default_keybindings = false,
	use_new_command = true,
})
