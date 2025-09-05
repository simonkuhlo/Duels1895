extends Node
class_name EntityStatHolderCollection

@export var mapped_collection:EntityStatCollection:
	set(new):
		if mapped_collection:
			unmap_collection(mapped_collection)
		mapped_collection = new
		if mapped_collection:
			map_collection(mapped_collection)

@export var mapped_holders:Array[EntityStatHolder]
@export var default_holder_scene:PackedScene:
	set(new):
		if new.instantiate() is not EntityStatHolder:
			push_error("Default holder scene must be EntityStatHolder")
			return
		default_holder_scene = new

func map_collection(collection:EntityStatCollection = mapped_collection) -> void:
	if !is_inside_tree():
		return
	for stat in collection.stats:
		var holder_instance:EntityStatHolder = default_holder_scene.instantiate()
		holder_instance.stat_to_represent = stat
		mapped_holders.append(holder_instance)
		add_child(holder_instance)

func unmap_collection(collection:EntityStatCollection = mapped_collection) -> void:
	for stat in collection:
		var found_holder:EntityStatHolder
		for holder in mapped_holders:
			if holder.stat_to_represent == stat:
				mapped_holders.erase(holder)
				holder.queue_free()
				return

func _ready() -> void:
	map_collection(mapped_collection)
