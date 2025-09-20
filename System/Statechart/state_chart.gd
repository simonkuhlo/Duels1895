@icon("res://System/Statechart/Assets/Icons/StateInterface.svg")
@tool
extends Node
class_name StateChart

@onready var root_state:StateChartState = _get_root_state()

func _get_root_state() -> StateChartState:
	for child in get_children():
		if child is StateChartState:
			child.state_chart = self
			return child
	push_error("No root state")
	return null

func _ready():
	if !Engine.is_editor_hint():
		root_state.activate()

func _process(delta):
	if !Engine.is_editor_hint():
		root_state.on_processing(delta)

func _physics_process(delta):	
	if !Engine.is_editor_hint():
		root_state.on_tick()
		root_state.on_physics_processing(delta)

func send_event(event:StringName):
	root_state.on_event_received(event)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	# TODO: Warn if
	## More than one states as direct children
	## No state as direct child

	return warnings
