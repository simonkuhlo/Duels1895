@icon("res://System/Statechart/Assets/Icons/ParallelState.svg")
@tool
extends ParentState
class_name ParallelState

## Called when State gets activated
func activate() -> void:
	super.activate()
	for child_state in child_states:
		child_state.activate()

func on_processing(delta) -> void:
	super.on_processing(delta)
	for child_state in child_states:
		child_state.on_processing(delta)

func on_physics_processing(delta) -> void:
	super.on_physics_processing(delta)
	for child_state in child_states:
		child_state.on_physics_processing(delta)

## Called when State gets deactivated
func deactivate() -> void:
	super.deactivate()
	for child_state in child_states:
		child_state.deactivate()

func on_tick():
	super.on_tick()
	if active:
		for child_state:StateChartState in child_states:
			child_state.on_tick()
