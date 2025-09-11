extends Node
class_name Inventory

signal slots_changed()
signal uid_changed()

@export var default_slot_scene:PackedScene
@export var default_slot_count:int = 0

@export var item_dropper:ItemDropper3D:
	set(new):
		item_dropper = new
		for slot in slots:
			slot.item_dropper = item_dropper

@export var uid_str:StringName:
	set(new):
		uid_str = new
		if !multiplayer.is_server():
			Items.register_inventory_id(self, uid_str)
		uid_changed.emit()

var slots:Array[InventorySlot] = []

func _ready() -> void:
	var index = 0
	for child in get_children():
		if child is InventorySlot:
			add_slot(child)
	if !default_slot_count:
		return
	while index < default_slot_count:
		var instance:InventorySlot = default_slot_scene.instantiate()
		add_slot(instance)
		index += 1

func add_slot(slot:InventorySlot) -> void:
	slot._parent_inventory = self
	slot.item_dropper = item_dropper
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
