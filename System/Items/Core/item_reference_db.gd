@tool
extends Resource
class_name ItemDB


@export var add_item:ItemReference:
	set(new):
		content[new.uid] = new
		changed.emit()

@export var default_icon:Texture2D
@export var default_world_item_scene:PackedScene
@export var default_held_item_scene:PackedScene

@export_group("System")
@export var content:Dictionary[StringName, ItemReference] = {}
