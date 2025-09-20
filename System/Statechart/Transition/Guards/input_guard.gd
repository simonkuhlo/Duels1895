@tool
extends TransitionGuard
class_name InputGuard

enum InputMode {TOGGLE, HOLD, PRESS}

##TRUE = Guard statisfied when input inactive
@export var invert_input:bool = false
@export var input_action:String
@export var input_mode:InputMode = InputMode.HOLD

var input_active:bool = false
var previous_input:bool = false

func _process(delta) -> void:
	if Input.is_action_pressed(input_action):
		match input_mode:
			InputMode.TOGGLE:
				if !previous_input:
					input_active = !input_active
			InputMode.HOLD:
				input_active = true
			InputMode.PRESS:
				input_active = true
			_:
				pass
		previous_input = true
	else:
		match input_mode:
			InputMode.TOGGLE:
				pass
			InputMode.HOLD:
				input_active = false
			InputMode.PRESS:
				pass
			_:
				pass

func is_statisfied() -> bool:
	if input_mode == InputMode.HOLD:
		return Input.is_action_pressed(input_action) != invert_input
	var return_value = input_active
	input_active = false
	if invert_input:
		return !return_value
	else:
		return return_value
