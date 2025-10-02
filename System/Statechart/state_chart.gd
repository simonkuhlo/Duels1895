@icon("res://System/Statechart/Assets/Icons/StateInterface.svg")
@tool
extends Node
class_name StateChart

@onready var root_state:StateChartState = _get_root_state()
@export var active:bool = true:
	set(new):
		active = new
		if root_state:
			root_state.active = active

func _get_root_state() -> StateChartState:
	for child in get_children():
		if child is StateChartState:
			return child
	push_error("No root state")
	return null

func _ready():
	if !active:
		return
	if Engine.is_editor_hint():
		return
	root_state.active = active

func _process(delta):
	if !active:
		return
	if Engine.is_editor_hint():
		return
	root_state.on_processing(delta)

func _physics_process(delta):
	if !active:
		return
	if Engine.is_editor_hint():
		return
	root_state.on_tick()
	root_state.on_physics_processing(delta)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	# TODO: Warn if
	## More than one states as direct children
	## No state as direct child

	return warnings
