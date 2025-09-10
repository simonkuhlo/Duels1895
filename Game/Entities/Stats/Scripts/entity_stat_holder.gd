extends Node
class_name EntityStatHolder

signal current_value_changed(new_value:float)

@export var stat_to_represent:EntityStat = EntityStat.new():
	set(new):
		stat_to_represent = new
		reset()

@export_group("linking")
@export var regen_block_timer:Timer

var current_value:float:
	set(new):
		new = clamp(new, stat_to_represent.min_value, stat_to_represent.max_value)
		if current_value > new or current_value < 0:
			if regen_block_timer.is_inside_tree():
				regen_block_timer.start(stat_to_represent.regen_delay_seconds)
		current_value = new
		current_value_changed.emit(current_value)

func reset() -> void:
	current_value = stat_to_represent.standard_value

func _physics_process(delta: float) -> void:
	if regen_block_timer.is_stopped():
		regen(delta)

func regen(delta:float) -> void:
	if !stat_to_represent.regen_per_second:
		return
	if current_value < stat_to_represent.max_value:
		current_value += stat_to_represent.regen_per_second * delta
