extends Inventory
class_name AmmoInventory

var held_ammo_instances:Array[ItemInstance] = []

##Returns an ItemInstance containing the content this element did was not able to receive
func receive_item(item:ItemInstance) -> ItemInstance:
	if item.item_reference is not AmmoItem:
		return item
	var reference:AmmoItem = item.item_reference
	if reference is AmmoItem:
		for ammo_instance in held_ammo_instances:
			if reference == ammo_instance.item_reference:
				ammo_instance.amount += item.amount
				content_updated.emit()
				return null
		held_ammo_instances.append(item)
		content_updated.emit()
	return null

func get_content(filter:BaseFilter = null) -> Array[ItemInstance]:
	var returned_array:Array[ItemInstance] = []
	for item in held_ammo_instances:
		if filter:
			if !filter.filter(item):
				continue
		returned_array.append(item)
	return returned_array

func get_held_amount(item:AmmoItem) -> int:
	return 0

func change_held_amount(item:AmmoItem, value:int) -> void:
	return
