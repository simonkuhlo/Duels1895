@tool
extends Resource
class_name ItemDB

@export var content:Dictionary[StringName, ItemReference] = {}
@export var add_item:ItemReference:
	set(new):
		content[new.uid] = new
