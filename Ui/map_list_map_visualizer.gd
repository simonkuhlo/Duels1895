extends PanelContainer
class_name MapListMapVisualizer

signal got_selected(visualizer:MapListMapVisualizer)

var map_to_visualize:MapResource:
	set(new):
		map_to_visualize = new
		if map_to_visualize:
			name_label.text = map_to_visualize.map_name
			max_player_label.text = str(map_to_visualize.max_players)

@export var name_label:Label
@export var max_player_label:Label



func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			got_selected.emit(self)
