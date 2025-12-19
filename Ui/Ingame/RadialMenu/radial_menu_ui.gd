extends CanvasLayer

@export var radial_menu:RadialMenu
@export var label:Label

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	radial_menu.option_selected.connect(_on_option_selected)
	radial_menu.hide()

func _on_option_selected(option:RadialMenuOption) -> void:
	if !option:
		label.text = ""
		return
	label.text = option.text

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select_ammo_type"):
		_on_show()
	elif Input.is_action_just_released("select_ammo_type"):
		_on_hide()

func _on_show() -> void:
	radial_menu.show()

func _on_hide() -> void:
	radial_menu.select()
	radial_menu.reset()
	radial_menu.hide()
