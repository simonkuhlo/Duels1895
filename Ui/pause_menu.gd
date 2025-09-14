extends CanvasLayer

@export var parent_world:MapInstance:
	set(new):
		if parent_world:
			parent_world.pause_state_changed.disconnect(_on_parent_world_pause_state_changed)
		parent_world = new
		if parent_world:
			parent_world.pause_state_changed.connect(_on_parent_world_pause_state_changed)

func _on_parent_world_pause_state_changed(new_state:bool) -> void:
	visible = new_state

func _on_resume_button_pressed() -> void:
	parent_world.paused = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
