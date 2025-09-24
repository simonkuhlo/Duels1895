@tool
extends TransitionGuard
class_name InputGuard

##Defines wether the guard should block and wait for the action_watcher's value to change after being statisfied once
@export var wait_for_reset:bool = false
@export var invert_value:bool = false
@export var input_action_watcher_to_watch:InputActionWatcher

func is_statisfied() -> bool:
	if !input_action_watcher_to_watch:
		return true
	return input_action_watcher_to_watch.action_active != invert_value
