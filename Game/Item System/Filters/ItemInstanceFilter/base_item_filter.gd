extends BaseFilter
class_name BaseItemFilter

func filter(item:Variant) -> bool:
	if item is not ItemInstance:
		return false
	return true
