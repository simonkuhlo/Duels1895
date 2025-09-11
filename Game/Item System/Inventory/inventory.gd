extends Node
class_name Inventory

signal slots_changed()
signal uid_changed()

@export var default_slot_scene:PackedScene
@export var default_slot_count:int = 0

@export var item_dropper:ItemDropper3D

@export var uid_str:StringName:
	set(new):
		uid_str = new
		if !multiplayer.is_server():
			Items.register_inventory_id(self, uid_str)
		uid_changed.emit()

var slots:Array[InventorySlot] = []
func add_slot(slot:InventorySlot) -> void:
	slot._parent_inventory = self
	if slot not in slots:
		slots.append(slot)
	if !slot.is_inside_tree():
		add_child(slot, true)
	slots_changed.emit()

func remove_slot(slot:InventorySlot) -> void:
	slots.erase(slot)
	slot.queue_free()
	slots_changed.emit()

func get_content(filter:BaseFilter = null) -> Array[ItemInstance]:
	var returned_array:Array[ItemInstance] = []
	for slot in slots:
		var instance:ItemInstance = slot.held_item
		if filter:
			if !filter.filter(instance):
				continue
		returned_array.append(instance)
	return returned_array

func get_free_slot() -> InventorySlot:
	for slot in slots:
		if !slot.has_item():
			return slot
	return

func has_free_slot() -> bool:
	if get_free_slot():
		return true
	return false
