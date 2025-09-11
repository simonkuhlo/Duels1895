extends Resource
class_name ItemReference

@export var id:StringName
@export var item_name:String
@export var description:String

@export var equipped_scene:PackedScene
@export var equipped_scene_fpv:PackedScene:
	get():
		if !equipped_scene_fpv:
			return equipped_scene
		return equipped_scene_fpv
