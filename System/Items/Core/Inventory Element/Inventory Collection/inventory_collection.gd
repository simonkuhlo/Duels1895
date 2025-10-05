extends InventoryElement
class_name InventoryCollection

@export var inventories:Array[Inventory] = []

func _ready() -> void:
	super._ready()
	for child in get_children():
		if child is Inventory:
			if child not in inventories:
				add_inventory(child)

func add_inventory(inventory:Inventory) -> void:
	inventories.append(inventory)

func remove_inventory(inventory:Inventory) -> void:
	inventories.erase(inventory)

func get_content(filter:BaseFilter = null) -> Array[ItemInstance]:
	var returned_array:Array[ItemInstance] = []
	if !inventories:
		return returned_array
	for inventory in inventories:
		returned_array.append_array(inventory.get_content(filter))
	return returned_array

##Adds a given item to the first free inventoryslot in the collection.
##If allow_split is true, it will fill already existing stacks first.
func add_item(item:ItemInstance, allow_split:bool = true) -> ItemInstance:
	var remaining_item:ItemInstance = item
	for inventory in inventories:
		remaining_item = inventory.add_item(item, allow_split)
		if !remaining_item:
			return
	return remaining_item

func receive_item(item:ItemInstance) -> ItemInstance:
	#TODO handle stacking
	var remaining_item:ItemInstance = item
	for inventory in inventories:
		remaining_item = inventory.receive_item(item)
		if !remaining_item:
			return
	return remaining_item
