extends WeaponItem
class_name GunItem

@export var ammo_family:AmmoItem.Family
@export var default_ammo:AmmoItem
@export var magazine_size:int = 1

@export var base_velocity:float = 1
@export var base_damage:float = 1

#func get_default_custom_properties() -> Dictionary[StringName, Variant]:
	#var custom_properties := super.get_default_custom_properties()
	#custom_properties.set("loaded_ammo_amount", magazine_size)
	#custom_properties.set("loaded_ammo_id", default_ammo.uid)
	#return custom_properties
