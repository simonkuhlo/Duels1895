extends Inventory
class_name AmmoInventory

var held_ammo_items:Dictionary[AmmoItem, ItemInstance] = {}

##Returns an ItemInstance containing the content this element did was not able to receive
func receive_item(item:ItemInstance) -> ItemInstance:
	if item.item_reference is not AmmoItem:
		return item
	var reference:AmmoItem = item.item_reference
	if reference is AmmoItem:
		if reference in held_ammo_items.keys():
			held_ammo_items[reference].amount += item.amount
		else:
			held_ammo_items[reference] = item
	content_updated.emit()
	return null

func get_content(filter:BaseFilter = null) -> Array[ItemInstance]:
	var returned_array:Array[ItemInstance] = []
	for item in held_ammo_items.keys():
		if filter:
			if !filter.filter(held_ammo_items[item]):
				continue
		returned_array.append(held_ammo_items[item])
	print(returned_array)
	return returned_array
		
