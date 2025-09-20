@icon("res://System/Statechart/Assets/Icons/StateTransition.svg")
@tool
extends Node
class_name StateTransition

signal transition_possible(transition:StateTransition)
signal transition_taken()

## The State this Transition leads to
@export var to:StateChartState:
	set(new_state):
		to = new_state
		name = "To" + new_state.name
		update_configuration_warnings()

## Private variable, use "guards"
var _cached_guards:Array[TransitionGuard] = []

## Array of Guards this State currently has
@onready var guards: Array[TransitionGuard]:
	get:
		if _cached_guards.is_empty():
			_add_all_guards()
		return _cached_guards

## Called when the Node enters the SceneTree
func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)
	child_order_changed.connect(_on_tree_changed)
	update_configuration_warnings()

## Called when this node gets a new Child
func _on_child_entered_tree(node) -> void:
	if node is TransitionGuard:
		_add_guard(node)
	update_configuration_warnings()

## Called when this node loses a Child
func _on_child_exiting_tree(node) -> void:
	if node is TransitionGuard:
		_remove_guard(node)
	update_configuration_warnings()

## Called when SceneTree has changed
func _on_tree_changed() -> void:
	update_configuration_warnings()

## Check all Guards if they are statisfied. If they are, signal that transition is possible
func try_transition() -> void:
	for guard:TransitionGuard in guards:
		if !guard.is_statisfied():
			return
	transition_possible.emit(self)

## Get all current guards of this Transition
func _add_all_guards() -> void:
	_cached_guards = []
	for child in get_children():
		if child is TransitionGuard:
			_cached_guards.append(child)

## Add a new guard 
func _add_guard(guard:TransitionGuard):
	_cached_guards.append(guard)
	update_configuration_warnings()
	
## Remove a guard 
func _remove_guard(guard:TransitionGuard):
	_cached_guards.erase(guard)
	update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if get_parent() is not StateChartState:
		warnings.append("This Node should only be the child of StateChartStates.")

	if to:
		if get_parent().get_parent() != to.get_parent():
			warnings.append("Trying to transition to a State that is not part of the same ParentState")
		if to == get_parent():
			warnings.append("Transitioning to own State.")
	else:
		warnings.append("Transition not configured: No State to transition to set.")
	return warnings
