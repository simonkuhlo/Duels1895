@icon("res://System/Statechart/Assets/Icons/StateInterface.svg")
@tool
extends StateChartState
class_name ParentState


var _cached_child_states: Array[StateChartState] = []
var child_states: Array[StateChartState]:
	get:
		if _cached_child_states.is_empty():
			_add_all_child_states()
		return _cached_child_states

func _ready() -> void:
	super._ready()

func _on_child_entered_tree(node) -> void:
	if node is StateChartState:
		_add_child_state(node)
	super._on_child_entered_tree(node)

func _on_child_exiting_tree(node) -> void:
	if node is StateChartState:
		_remove_child_state(node)
	super._on_child_entered_tree(node)

func on_tick() -> void:
	super.on_tick()
	for child_state in child_states:
		child_state.on_tick()

func _add_all_child_states() -> void:
	_cached_child_states = []
	for child in get_children():
		if child is StateChartState:
			_add_child_state(child)

func _add_child_state(child_state:StateChartState) -> void:
	if child_state not in _cached_child_states:
		_cached_child_states.append(child_state)
	if Engine.is_editor_hint():
		update_configuration_warnings()

func _remove_child_state(child_state:StateChartState) -> void:
	_cached_child_states.erase(child_state)
	if !Engine.is_editor_hint():
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if child_states.is_empty():
		warnings.append("No child states found.")
	return warnings
