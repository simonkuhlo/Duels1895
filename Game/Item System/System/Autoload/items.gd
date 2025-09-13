extends Node
class_name ItemSingleton

@export var item_db:ItemDB

func get_item_by_id(id:StringName) -> ItemReference:
	return item_db.content.get(id)

var registered_slots:Dictionary[String, InventorySlot]
func get_slot_uid(slot:InventorySlot) -> String:
	if !registered_slots.find_key(slot):
		var new_id = str("slot" + str(registered_slots.size()))
		registered_slots.set(new_id, slot)
	var returned_id:String = registered_slots.find_key(slot)
	return returned_id

func register_slot_uid(slot:InventorySlot, uid:String) -> void:
	registered_slots.set(uid, slot)
