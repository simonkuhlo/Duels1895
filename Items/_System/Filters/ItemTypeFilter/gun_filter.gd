extends BaseItemFilter
class_name GunFilter

@export var allowed_ammo_families:Array[AmmoItem.Family]

func filter(item:Variant) -> bool:
	if !super.filter(item):
		return false
	var instance:ItemInstance 
	if item is ItemInstance:
		instance = item
	else:
		return false
	if instance.item_reference is not GunItem:
		return false
	if !filter_ammo_families(instance.item_reference):
		return false
	return true

func filter_ammo_families(item_resource:GunItem) -> bool:
	if !allowed_ammo_families:
		return true
	for family in allowed_ammo_families:
		if item_resource.ammo_familiy == family:
			return true
	return false
