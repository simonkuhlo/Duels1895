extends Node3D

@export var resource_to_spawn:ItemInstance

func _ready() -> void:
	if multiplayer.is_server():
		var world_item:WorldItem = resource_to_spawn.item_reference.world_item.instantiate()
		world_item._held_slot.receive_item(resource_to_spawn.duplicate())
		add_child(world_item)
