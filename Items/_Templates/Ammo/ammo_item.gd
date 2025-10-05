@tool
extends ItemReference
class_name AmmoItem

enum Family {SMALL, MEDIUM, LONG, SPECIAL}

@export var family:Family

@export var damage_modifier:float = 1
@export var velocity_modifier:float = 1
@export var max_range:float = 1000
@export var damage_falloff:Curve

func _defaults() -> void:
	max_stack_size = 0
	special = true
