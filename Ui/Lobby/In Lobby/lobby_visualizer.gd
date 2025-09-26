extends Control

@export var test_world:MapResource

func _on_leave_button_pressed() -> void:
	Lobby.leave_lobby()


func _on_start_button_pressed() -> void:
	if !multiplayer.is_server():
		return
	MapLoader.initialize_load_process(test_world)
