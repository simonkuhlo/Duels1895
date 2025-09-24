@icon("res://System/Statechart/Assets/Icons/AtomicState.svg")
@tool
extends StateChartState
class_name AtomicState

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if get_parent() is not ParentState:
		warnings.append("AtomicStates need to be the Child of a ParentState.")
		
	if get_parent() is CompoundState:
		if !transitions:
			warnings.append("This State has no Transitions, but is the child of a CompundState")
	
	for child in get_children():
		if not child is StateTransition:
			warnings.append("Child node '%s' is not a StateTransition. Only StateTransition nodes should be added as children." % child.name)
		if child is StateChartState:
			warnings.append("Child node '%s' is a StateChartState. AtomicStates can't take States as children." % child.name)
	return warnings
