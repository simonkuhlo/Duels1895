extends Node

@export var synchronized_holder:ItemHolder3D:
	set(new):
		if synchronized_holder:
			synchronized_holder.held_slot_changed.disconnect(_on_synchronized_holder_held_slot_changed)
		synchronized_holder = new
		if synchronized_holder:
			synchronized_holder.held_slot_changed.connect(_on_synchronized_holder_held_slot_changed)

@export var synchronized_held_slot_uid:StringName:
	set(new):
		if synchronized_held_slot_uid:
			pass
		synchronized_held_slot_uid = new
		if is_multiplayer_authority():
			return
		if synchronized_held_slot_uid:
			synchronized_holder.held_slot = Items.get_element_by_uid(synchronized_held_slot_uid)

func _on_synchronized_holder_held_slot_changed(new_slot:InventorySlot) -> void:
	if is_multiplayer_authority():
		if !new_slot:
			return
		synchronized_held_slot_uid = new_slot.uid
