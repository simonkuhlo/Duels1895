@tool
extends Resource
class_name MapDB

@export var maps:Dictionary[StringName, MapResource] = {}
@export var add_map:MapResource:
	set(new):
		maps.set(new.uid, new)

func get_map(id:StringName) -> MapResource:
	return maps.get(id)
