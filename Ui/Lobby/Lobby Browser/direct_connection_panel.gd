extends PanelContainer

@export var address_edit:LineEdit
@export var port_edit:SpinBox
@export var password_edit:LineEdit

func _ready() -> void:
	visibility_changed.connect(setup)
	setup()

func setup() -> void:
	address_edit.text = Settings.connection_settings.remote_address
	port_edit.value = Settings.connection_settings.game_port
	password_edit.text = Settings.connection_settings.lobby_password

func save() -> void:
	Settings.connection_settings.remote_address = address_edit.text
	Settings.connection_settings.game_port = port_edit.value
	Settings.connection_settings.lobby_password = password_edit.text

func _on_join_button_pressed() -> void:
	save()
	Lobby.create_client()

func _on_password_visible_toggle_toggled(toggled_on: bool) -> void:
	password_edit.secret = toggled_on
