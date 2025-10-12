@tool
extends WeaponItem
class_name GunItem

@export var ammo_family:AmmoItem.Family
@export var default_ammo:AmmoItem
@export var magazine_size:int = 1

@export var base_velocity:float = 1
@export var base_damage:float = 1

const PROPERTY_LOADED_AMMO_AMOUNT_STR = "loaded_ammo_amount"
const PROPERTY_LOADED_AMMO_TYPE_STR = "loaded_ammo_id"

func get_default_custom_properties() -> Dictionary[StringName, Variant]:
	var custom_properties := super.get_default_custom_properties()
	custom_properties.set(PROPERTY_LOADED_AMMO_AMOUNT_STR, magazine_size)
	custom_properties.set(PROPERTY_LOADED_AMMO_TYPE_STR, default_ammo.uid)
	return custom_properties
