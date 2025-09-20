extends InventorySlotVisualizer
class_name HotbarSlotVisualizer

var selected:bool:
	set(new):
		selected = new
		if selected:
			# Get the current stylebox used for the panel or create a new one
			var stylebox := get_theme_stylebox("panel").duplicate()
			# Change its background color property
			stylebox.set("bg_color", Color(1, 0, 0, 0.19)) # Red color
			stylebox.border_width_left = 2
			stylebox.border_width_top = 2
			stylebox.border_width_right = 2
			stylebox.border_width_bottom = 2
			stylebox.border_color = Color(1, 0, 0)  # Red border
			add_theme_stylebox_override("panel", stylebox)
		else:
			set("theme_override_styles/panel", null)
