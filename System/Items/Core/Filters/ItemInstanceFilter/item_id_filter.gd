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
	var filtered_item:ItemReference = item
	for accepted_item in accepted_items:
		if filtered_item.uid == accepted_item.uid:
			return true
	return false
