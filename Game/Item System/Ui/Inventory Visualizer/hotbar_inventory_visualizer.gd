extends InventoryVisualizer
class_name HotbarInventoryVisualizer

var select_index:int:
	set(new):
		if new >= visualizer_mapping.size():
			new = 0
		elif new < 0:
			new = visualizer_mapping.size() - 1
		select_index = new
		selected_visualizer = visualizer_mapping.get(select_index)

var selected_visualizer:HotbarSlotVisualizer:
	set(new):
		if selected_visualizer:
			selected_visualizer.selected = false
		selected_visualizer = new
		if selected_visualizer:
			selected_visualizer.selected = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hotbar_next_item"):
		select_index += 1
	if event.is_action_pressed("hotbar_prev_item"):
		select_index -= 1

func visualize_slots() -> void:
	super.visualize_slots()
	select_index = 0
