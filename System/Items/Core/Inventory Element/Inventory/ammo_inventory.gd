extends Inventory
class_name AmmoInventory

var held_ammo_items:Dictionary[AmmoItem, int] = {}

##Returns an ItemInstance containing the content this element did was not able to receive
func receive_item(item:ItemInstance) -> ItemInstance:
	if item.item_reference is not AmmoItem:
		return item
	var reference:AmmoItem = item.item_reference
	if reference is AmmoItem:
		if reference in held_ammo_items.keys():
			held_ammo_items[reference] = held_ammo_items[reference] + item.amount
		else:
			held_ammo_items[reference] = item.amount
	content_updated.emit()
	return null

func get_content(filter:BaseFilter = null) -> Array[ItemInstance]:
	var returned_array:Array[ItemInstance] = []
	for item in held_ammo_items.keys():
		var item_instance = ItemInstance.new()
		item_instance.item_reference = item
		item_instance.amount = held_ammo_items.get(item)
		if filter:
			if !filter.filter(item_instance):
				continue
		returned_array.append(item_instance)
	return returned_array
		
