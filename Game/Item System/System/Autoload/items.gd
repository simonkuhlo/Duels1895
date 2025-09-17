extends Node
class_name ItemSingleton

@export var item_db:ItemDB

func get_item_by_id(id:StringName) -> ItemReference:
	return item_db.content.get(id)

var registered_inventory_elements:Dictionary[String, InventoryElement]

func get_element_by_uid(id:StringName) -> InventoryElement:
	return registered_inventory_elements.get(id)

func get_element_uid(element:InventoryElement) -> String:
	if !registered_inventory_elements.find_key(element):
		var new_id = str("ie_" + str(registered_inventory_elements.size()))
		registered_inventory_elements.set(new_id, element)
	var returned_id:String = registered_inventory_elements.find_key(element)
	return returned_id

func register_element_uid(element:InventoryElement, uid:String) -> void:
	registered_inventory_elements.set(uid, element)
