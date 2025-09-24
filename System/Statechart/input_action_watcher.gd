extends Node
class_name InputActionWatcher

enum InputMode {TOGGLE, HOLD, PRESS}

@export var action:String
@export var input_mode:InputMode = InputMode.TOGGLE

var action_active:bool = false

var pressed_previously:bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(action):
		match input_mode:
			InputMode.HOLD:
				action_active = true
			InputMode.PRESS:
				action_active = !event.is_echo()
			InputMode.TOGGLE:
				action_active = !action_active
	if event.is_action_released(action):
		match input_mode:
			InputMode.HOLD:
				action_active = false
			InputMode.PRESS:
				action_active = false
