extends Control

@export var connection_settings_editor:Control
@export var lobby_creator:Control

func _on_join_button_pressed() -> void:
	Lobby.create_client()

func _on_create_button_pressed() -> void:
	lobby_creator.show()

func _on_connection_settings_pressed() -> void:
	connection_settings_editor.show()
