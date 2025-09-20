@icon("res://System/Statechart/Assets/Icons/TransitionGuard.svg")
@tool
extends Node
class_name TransitionGuard

var _state_chart:StateChart

## Reference to the parent StateChart
var state_chart:StateChart:
	set(new_state_chart):
		_edit_state_chart(new_state_chart)
	get:
		return _state_chart

func _edit_state_chart(new_state_chart) -> void:
	_state_chart = new_state_chart

func is_statisfied() -> bool:
	return false
