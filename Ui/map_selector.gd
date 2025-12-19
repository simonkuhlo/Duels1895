extends PanelContainer

@export var list_root:Control
@export var visualizer_scene:PackedScene

@export var preview_name_label:Label

var selected_map:MapResource:
	set(new):
		selected_map = new
		update_map_preview()

func _ready() -> void:
	setup()
	selected_map = MapLoader.map_db.get_map_list()[0]

func setup() -> void:
	clear()
	for map in MapLoader.map_db.get_map_list():
		var visualizer_instance:MapListMapVisualizer = visualizer_scene.instantiate()
		visualizer_instance.map_to_visualize = map
		visualizer_instance.got_selected.connect(_on_visualizer_got_selected)
		list_root.add_child(visualizer_instance)

func clear() -> void:
	for child in list_root.get_children():
		if child is MapListMapVisualizer:
			child.got_selected.disconnect(_on_visualizer_got_selected)
			child.queue_free()

func _on_visualizer_got_selected(visualizer:MapListMapVisualizer) -> void:
	selected_map = visualizer.map_to_visualize

func update_map_preview() -> void:
	preview_name_label.text = selected_map.map_name


func _on_start_button_pressed() -> void:
	if !multiplayer.is_server():
		return
	if !selected_map:
		return
	MapLoader.initialize_load_process(selected_map)
