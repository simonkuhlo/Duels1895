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
	return null
