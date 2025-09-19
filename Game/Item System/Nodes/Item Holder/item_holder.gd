extends Node3D
class_name ItemHolder3D

signal held_slot_changed(new_slot:InventorySlot)

var parent_entity:EntityBody3D

var held_slot:InventorySlot:
	set(new):
		if held_slot:
			held_slot.item_switched.disconnect(_on_held_slot_item_switched)
		held_slot = new
		if held_slot:
			held_slot.item_switched.connect(_on_held_slot_item_switched)
			_on_held_slot_item_switched(held_slot.held_item)
		else:
			_on_held_slot_item_switched(null)
		held_slot_changed.emit(held_slot)

var held_item_instance:ItemInstance:
	set(new):
		if held_item_instance:
			pass
		held_item_instance = new
		if held_item_instance:
			pass
		equipped_scene_instance = get_held_item_equipped_scene_instance(held_item_instance)

var equipped_scene_instance:EquippedItem:
	set(new):
		if equipped_scene_instance:
			equipped_scene_instance.queue_free()
		equipped_scene_instance = new
		if equipped_scene_instance:
			add_child(equipped_scene_instance)

func _on_held_slot_item_switched(new_item:ItemInstance) -> void:
	held_item_instance = new_item

func get_held_item_equipped_scene_instance(item:ItemInstance) -> EquippedItem:
	if !item:
		return
	if held_item_instance.item_reference.equipped_scene_fpv:
		return held_item_instance.item_reference.equipped_scene_fpv.instantiate()
	if held_item_instance.item_reference.equipped_scene:
		return held_item_instance.item_reference.equipped_scene.instantiate()
	if Items.item_db.default_held_item_scene:
		return Items.item_db.default_held_item_scene.instantiate()
	return
