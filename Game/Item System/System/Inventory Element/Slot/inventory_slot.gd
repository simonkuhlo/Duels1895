extends InventoryElement
class_name InventorySlot

signal item_switched(new_item:ItemInstance)

@export var filter:BaseFilter

@export var item_dropper:ItemDropper3D

var _parent_inventory:Inventory

var held_item:ItemInstance:
	set(new):
		if held_item:
			held_item.properties_changed.disconnect(_on_held_item_properites_changed)
		held_item = new
		if held_item:
			held_item.properties_changed.connect(_on_held_item_properites_changed)
		item_switched.emit(held_item)

func _on_held_item_properites_changed() -> void:
	if held_item.amount <= 0:
		held_item = null

func has_item() -> bool:
	if held_item:
		return true
	return false

func try_stack(item:ItemInstance) -> ItemInstance:
	if held_item:
		if held_item.item_reference == item.item_reference:
			var free_amount:int = held_item.item_reference.max_stack_size - held_item.amount
			var added_amount:int = clamp(item.amount, 0, free_amount)
			held_item.amount += added_amount
			item.amount -= added_amount
			if item.amount <= 0:
				item = null
	else:
		if filter:
			if !filter.filter(item):
				return item
		held_item = item
		item = null
	return item

## Returns the replaced item
func set_held_item(item:ItemInstance) -> ItemInstance:
	var replaced_item = held_item
	held_item = item
	return replaced_item

func receive_item(item:ItemInstance) -> ItemInstance:
	#TODO handle stacking
	if !item:
		return
	if held_item:
		if item.item_reference.uid != held_item.item_reference.uid:
			return item
		var max_amount:int = held_item.item_reference.max_stack_size
		if held_item.amount < max_amount:
			var added_amount:int = mini(max_amount - held_item.amount, item.amount)
			held_item.amount += added_amount
			item.amount -= added_amount
			if item.amount <= 0:
				item = null
		elif !max_amount:
			held_item.amount += item.amount
			item = null
		return item
	held_item = item
	return 

func transfer_content(target:InventoryElement) -> void:
	if multiplayer.is_server():
		held_item = target.receive_item(held_item)
	else:
		request_transfer_content.rpc_id(1, target.uid)

@rpc("any_peer", "call_local", "reliable")
func request_transfer_content(target_id:StringName) -> void:
	transfer_content(Items.get_element_by_uid(target_id))
