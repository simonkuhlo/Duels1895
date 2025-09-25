extends Control

@export var lobby_creator:Control
@export var lobby_browser:Control

func _on_join_button_pressed() -> void:
	lobby_browser.show()

func _on_create_button_pressed() -> void:
	lobby_creator.show()

func _on_create_lobby_button_pressed() -> void:
	lobby_creator.show()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
