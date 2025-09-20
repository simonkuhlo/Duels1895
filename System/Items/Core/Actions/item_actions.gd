extends Node
class_name ItemActions

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
	else:
		var temp_item:ItemInstance = target_slot.set_held_item(source_slot.held_item)
		source_slot.held_item

@rpc("any_peer", "call_local", "reliable")
func transfer_slot_to_slot_rpc(source_slot_id:String, target_slot_id:String, swap:bool) -> void:
	var source_slot:InventorySlot = Items.get_slot_by_uid(source_slot_id)
	var target_slot:InventorySlot = Items.get_slot_by_uid(target_slot_id)
	transfer_slot_to_slot(source_slot, target_slot, swap)

func transfer_slot_to_inventory(source_slot:InventorySlot, target_inventory:Inventory) -> void:
	if !source_slot:
		return
	if !target_inventory:
		return
	if !multiplayer.is_server():
		transfer_slot_to_slot_rpc.rpc_id(1, source_slot.uid_str, target_inventory.uid_str)

@rpc("any_peer", "call_local", "reliable")
func transfer_slot_to_inventory_rpc(source_slot_id:String, target_inventory_id:String) -> void:
	var source_slot:InventorySlot = Items.get_slot_by_uid(source_slot_id)
	var target_inventory:Inventory
	transfer_slot_to_inventory(source_slot, target_inventory)

func transfer_slot_to_collection(source_slot:InventorySlot, target_collection:InventoryCollection) -> void:
	pass
