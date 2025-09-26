extends PanelContainer

@export var title_edit:LineEdit
@export var password_edit:LineEdit
@export var connection_type_select:OptionButton
@export var discovery_server_edit:LineEdit
@export var game_port_edit:SpinBox
@export var max_players_edit:SpinBox

func _ready() -> void:
	visibility_changed.connect(setup)
	setup()

func _on_create_button_pressed() -> void:
	save()
	Lobby.create_server()

func setup() -> void:
	if !visible:
		return
	title_edit.text = Settings.connection_settings.lobby_title
	password_edit.text = Settings.connection_settings.lobby_password
	discovery_server_edit.text = Settings.connection_settings.discovery_server_address
	game_port_edit.value = Settings.connection_settings.game_port
	max_players_edit.value = Settings.connection_settings.max_players

func save() -> void:
	Settings.connection_settings.lobby_title = title_edit.text
	Settings.connection_settings.lobby_password = password_edit.text
	Settings.connection_settings.discovery_server_address = discovery_server_edit.text
	Settings.connection_settings.game_port = game_port_edit.value
	Settings.connection_settings.max_players = max_players_edit.value

func _on_cancel_button_pressed() -> void:
	hide()

func _on_hide_password_toggled(toggled_on: bool) -> void:
	password_edit.secret = toggled_on
