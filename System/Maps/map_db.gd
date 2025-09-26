@tool
extends Resource
class_name MapDB

@export var maps:Dictionary[StringName, MapResource] = {}
@export var add_map:MapResource:
	set(new):
		maps.set(new.uid, new)

func get_map(id:StringName) -> MapResource:
	return maps.get(id)

func get_map_list(filter:BaseFilter = null) -> Array[MapResource]:
	var returned_maps:Array[MapResource] = []
	for map in maps.values():
		if filter:
			if !filter.filter(map):
				continue
		returned_maps.append(map)
	return returned_maps
