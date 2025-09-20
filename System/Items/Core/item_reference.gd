extends Resource
class_name ItemReference

@export var uid:StringName
@export var item_name:String
@export var description:String
@export var icon:Texture2D

@export var max_stack_size:int = 100

@export var equipped_scene:PackedScene
@export var equipped_scene_fpv:PackedScene:
	get():
		if !equipped_scene_fpv:
			return equipped_scene
		return equipped_scene_fpv

@export var world_item:PackedScene

func get_default_custom_properties() -> Dictionary[StringName, Variant]:
	return {}
