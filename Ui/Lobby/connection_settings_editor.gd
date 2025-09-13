extends Control

@export var player_name_edit:LineEdit
@export var remote_address_edit:LineEdit
@export var max_players_spinbox:SpinBox
@export var game_port_spinbox:SpinBox

func _ready() -> void:
	setup()

func setup() -> void:
	player_name_edit.text = Settings.connection_settings.used_profile.player_name
	remote_address_edit.text = Settings.connection_settings.remote_address
	max_players_spinbox.value = Settings.connection_settings.max_players
	game_port_spinbox.value = Settings.connection_settings.game_port

func save() -> void:
	Settings.connection_settings.used_profile.player_name = player_name_edit.text
	Settings.connection_settings.remote_address = remote_address_edit.text
	Settings.connection_settings.max_players = max_players_spinbox.value
	Settings.connection_settings.game_port = game_port_spinbox.value

func close() -> void:
	queue_free()

func _on_cancel_button_pressed() -> void:
	hide()
	setup()

func _on_apply_button_pressed() -> void:
	save()
	hide()
	setup()
