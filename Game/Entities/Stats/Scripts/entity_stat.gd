@tool
extends Resource
class_name EntityStat

@export var stat_type:EntityStatType:
	set(new):
		stat_type = new
		resource_name = stat_type.name

@export var min_value:float = 0

@export var max_value:float = 10

@export var standard_value:float = max_value

@export var regen_per_second:float = 0
