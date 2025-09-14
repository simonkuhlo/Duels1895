extends Node
class_name ItemActions

func pickup_world_item(world_item:WorldItem, entity:EntityBody3D) -> void:
	pass

func transfer_slot_to_slot(source_slot:InventorySlot, target_slot:InventorySlot, swap:bool) -> void:
	if !source_slot:
		return
	if !target_slot:
		return
	if !multiplayer.is_server():
		transfer_slot_to_slot_rpc.rpc_id(1, source_slot.uid_str, target_slot.uid_str, swap)
	if !swap:
		if target_slot.held_item:
			return

@rpc("any_peer", "call_local", "reliable")
func transfer_slot_to_slot_rpc(source_slot_id:String, target_slot_id:String, swap:bool) -> void:
	var source_slot:InventorySlot
	var target_slot:InventorySlot
	transfer_slot_to_slot(source_slot, target_slot, swap)

func transfer_slot_to_inventory(source_slot:InventorySlot, target_inventory:Inventory) -> void:
	pass

func transfer_slot_to_collection(source_slot:InventorySlot, target_collection:InventoryCollection) -> void:
	pass
