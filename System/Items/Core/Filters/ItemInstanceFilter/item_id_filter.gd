@tool
extends BaseItemFilter
class_name ItemIdFilter

@export var accepted_items:Array[ItemReference]

func _defaults() -> void:
	super._defaults()
	accept_special = true

func filter(item:Variant) -> bool:
	if !super.filter(item):
		return false
	var filtered_item:ItemInstance = item
	print(accepted_items)
	for accepted_item in accepted_items:
		print(accepted_item.uid, "-",filtered_item.item_reference.uid)
		if filtered_item.item_reference.uid == accepted_item.uid:
			return true
	return false
