@icon("res://System/Statechart/Assets/Icons/StateInterface.svg")
@tool
extends Node
class_name StateChartState

## Emitted when State wants to transition
signal want_transition(transition:StateTransition)

## Emitted when State gets activated
signal activated()

## Emitted when active and processing (once per frame)
signal processing(delta)

## Emitted when active and physics_processing (once per physics tick)
signal physics_processing(delta)

## Emitted when State gets deactivated
signal deactivated()

## Wether the state is cuerrently active or not
var active:bool = false:
	set(new):
		active = new
		if active:
			activated.emit()
			_on_activated()
		else:
			deactivated.emit()
			_on_deactivated()


## Private variable, use "transitions"
var _cached_transitions:Array[StateTransition] = []

## Array of Transitions this State currently has
var transitions: Array[StateTransition]:
	get:
		if _cached_transitions.is_empty():
			_add_all_transitions()
		return _cached_transitions

func _on_activated() -> void:
	pass

func _on_deactivated() -> void:
	pass

## Called when the Node enters the SceneTree
func _ready() -> void:
	if !Engine.is_editor_hint():
		pass
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)
	child_order_changed.connect(_on_tree_changed)
	if Engine.is_editor_hint():
		update_configuration_warnings()

## Called when this node gets a new Child
func _on_child_entered_tree(node) -> void:
	if node is StateTransition:
		_add_transition(node)
	update_configuration_warnings()

## Called when this node loses a Child
func _on_child_exiting_tree(node) -> void:
	if node is StateTransition:
		_remove_transition(node)
	update_configuration_warnings()

## Called when SceneTree has changed
func _on_tree_changed() -> void:
	update_configuration_warnings()

## Called every StateChart tick
func on_tick() -> void:
	if active:
		_try_transitions()

## Called when active and processing (once per frame)
func on_processing(delta) -> void:
	if active:
		emit_signal("processing", delta)

## Called when active and physics_processing (once per physics tick)
func on_physics_processing(delta) -> void:
	if active:
		emit_signal("physics_processing", delta)

## Called when State gets activated
func activate() -> void:
	active = true

## Called when State gets deactivated
func deactivate() -> void:
	active = false

## Called when a child transition signals that the transition is possible
func _on_transition_possible(transition:StateTransition) -> void:
	if active:
		transition.transition_taken.emit()
		want_transition.emit(transition)

## Try all transitions that don't have a specific Trigger
func _try_transitions() -> void:
	if Engine.is_editor_hint():
		return
	for transition:StateTransition in transitions:
		transition.try_transition()

## Get all current Transitions of this State
func _add_all_transitions() -> void:
	for child in get_children():
		if child is StateTransition:
			_add_transition(child)

## Add a new transition to this state
func _add_transition(transition:StateTransition) -> void:
	if !Engine.is_editor_hint():
		transition.transition_possible.connect(_on_transition_possible)
	_cached_transitions.append(transition)
	update_configuration_warnings()

## Add a new transition to this state
func _remove_transition(transition:StateTransition) -> void:
	if !Engine.is_editor_hint():
		if transition.transition_possible.is_connected(_on_transition_possible):
			transition.disconnect("transition_possible", _on_transition_possible)
	_cached_transitions.erase(transition)
	update_configuration_warnings()
