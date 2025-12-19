extends Node3D

@export var parent_map:MapInstance
@export var resource_to_spawn:ItemInstance

func _ready() -> void:
	if multiplayer.is_server():
		var item = resource_to_spawn.duplicate()
		item.reset_properties()
		_spawn_item.call_deferred(resource_to_spawn.duplicate())

func _spawn_item(item:ItemInstance) -> void:
	if multiplayer.is_server():
		var world_item:WorldItem
		if resource_to_spawn.item_reference.world_item:
			world_item = resource_to_spawn.item_reference.world_item.instantiate()
		else:
			world_item = Items.item_db.default_world_item_scene.instantiate()
		world_item._held_slot.receive_item(item)
		world_item.transform = global_transform
		parent_map.add_child(world_item, true)
