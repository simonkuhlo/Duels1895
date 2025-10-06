extends CanvasLayer

@export var radial_menu:Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select_ammo_type"):
		radial_menu.show()
	elif Input.is_action_just_released("select_ammo_type"):
		radial_menu.hide()
