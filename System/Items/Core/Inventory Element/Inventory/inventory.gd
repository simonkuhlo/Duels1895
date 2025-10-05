extends InventoryElement
class_name Inventory


func get_content(filter:BaseFilter = null) -> Array[ItemInstance]:
	return []

##Returns an ItemInstance containing the content this element did was not able to receive
func receive_item(item:ItemInstance) -> ItemInstance:
	return item
