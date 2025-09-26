extends PanelContainer

@export var name_edit:LineEdit

func _ready() -> void:
	setup()

func setup() -> void:
	name_edit.text = Settings.connection_settings.used_profile.player_name

func save() -> void:
	Settings.connection_settings.used_profile.player_name = name_edit.text

func _on_save_button_pressed() -> void:
	save()
	setup()
