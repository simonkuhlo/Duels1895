extends BaseFilter
class_name BaseItemFilter

@export var accept_special:bool = false

func filter(item:Variant) -> bool:
	if item is not ItemInstance:
		return false
	if !accept_special:
		if item.item_reference.special:
			return false
	return true
