extends Node
class_name InventorySlot

signal item_switched(new_item:ItemInstance)
signal uid_changed()

@export var uid_str:StringName:
	set(new):
		uid_str = new
		if !multiplayer.is_server():
			Items.register_slot_id(self, uid_str)
		uid_changed.emit()

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

func _ready() -> void:
	if multiplayer.is_server():
		uid_str = Items.get_slot_id(self)

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
