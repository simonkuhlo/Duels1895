@icon("res://System/Statechart/Assets/Icons/ActiveStateGuard.svg")
@tool
extends TransitionGuard
class_name DelayGuard

@export var state_to_watch:StateChartState

@export var delay_seconds:float = 0: 
	set(seconds):
		delay_seconds = seconds
		update_configuration_warnings()

var timer:Timer = Timer.new()

func _ready():
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = delay_seconds
	add_child(timer)
	state_to_watch.activated.connect(_on_state_to_watch_activated)

func _on_state_to_watch_activated():
	timer.start()

func is_statisfied() -> bool:
	if timer.is_stopped():
		return true
	return false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	return warnings
