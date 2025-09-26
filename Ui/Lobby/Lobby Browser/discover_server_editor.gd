extends HBoxContainer

@export var discovery_server_edit:LineEdit

func _ready() -> void:
	setup()

func setup() -> void:
	discovery_server_edit.text = Settings.connection_settings.discovery_server_address

func save() -> void:
	Settings.connection_settings.discovery_server_address = discovery_server_edit.text

func _on_change_button_pressed() -> void:
	save()
