extends BaseItemFilter
class_name AmmoFilter

@export var allowed_ammo_families:Array[AmmoItem.Family]

func _defaults() -> void:
	super._defaults()
	accept_special = true

func filter(item:Variant) -> bool:
	if !super.filter(item):
		return false
	var instance:ItemInstance 
	if item is ItemInstance:
		instance = item
	else:
		return false
	if instance.item_reference is not AmmoItem:
		return false
	if !filter_ammo_families(instance.item_reference):
		return false
	return true

func filter_ammo_families(item_resource:AmmoItem) -> bool:
	if !allowed_ammo_families:
		return true
	for family in allowed_ammo_families:
		if item_resource.family == family:
			return true
	return false
