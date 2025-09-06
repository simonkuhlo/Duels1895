extends CharacterBody3D
class_name EntityBody3D


@export_group("Setup")
@export var stat_holder_scene:PackedScene:
	set(new):
		if new.instantiate() is not EntityStatHolder:
			push_error("stat holder scene must be EntityStatHolder")
			return
		stat_holder_scene = new
@export var health:EntityStatHolder
@export var move_speed:EntityStatHolder
