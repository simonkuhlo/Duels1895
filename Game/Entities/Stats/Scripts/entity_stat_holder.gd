extends Node
class_name EntityStatHolder

signal current_value_changed(new_value:float)

@export var stat_to_represent:EntityStat:
	set(new):
		stat_to_represent = new
		if stat_to_represent:
			name = stat_to_represent.stat_type.name
		else:
			queue_free()
			return
		reset()

var current_value:float:
	set(new):
		new = clamp(new, stat_to_represent.min_value, stat_to_represent.max_value)
		current_value = new
		current_value_changed.emit(current_value)

func reset() -> void:
	current_value = stat_to_represent.standard_value

func _physics_process(delta: float) -> void:
	regen(delta)

func regen(delta:float) -> void:
	if !stat_to_represent.regen_per_second:
		return
	if current_value < stat_to_represent.max_value:
		current_value += stat_to_represent.regen_per_second * delta
