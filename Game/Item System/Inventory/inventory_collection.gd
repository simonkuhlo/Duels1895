extends Node
class_name InventoryCollection

@export var inventories:Array[Inventory] = []

func add_inventory(inventory:Inventory) -> void:
	inventories.append(inventory)

func remove_inventory(inventory:Inventory) -> void:
	inventories.erase(inventory)

func get_content(filter:BaseFilter = null) -> Array[ItemInstance]:
	var returned_array:Array[ItemInstance] = []
	for inventory in inventories:
		returned_array.append_array(inventory.get_content(filter))
	return returned_array

func get_items_by_uid(uid:StringName) -> Array[ItemInstance]:
	var returned_array:Array[ItemInstance] = []
	for inventory in inventories:
		returned_array.append_array(inventory.get_items_by_id(uid))
	return returned_array
