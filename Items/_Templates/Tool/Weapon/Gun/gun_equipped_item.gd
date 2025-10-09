extends EquippedWeapon
class_name EquippedGun

signal loaded_ammo_changed()
signal loaded_ammo_amount_changed()

var filtered_gun_ref:GunItem


var set_loaded_ammo:AmmoItem:
	set(new):
		if loaded_ammo:
			_get_available_ammo(true)[0].amount += loaded_ammo_amount
			loaded_ammo_amount = 0
		instance.set_property(filtered_gun_ref.PROPERTY_LOADED_AMMO_TYPE_STR, loaded_ammo.uid)
	get():
		return loaded_ammo

var loaded_ammo:AmmoItem:
	set(new):
		loaded_ammo = new
		loaded_ammo_changed.emit()

var loaded_ammo_amount:int:
	set(new):
		if !instance:
			return
		instance.set_property(filtered_gun_ref.PROPERTY_LOADED_AMMO_AMOUNT_STR, new)
	get():
		if !instance:
			return 0
		return instance.get_property(filtered_gun_ref.PROPERTY_LOADED_AMMO_AMOUNT_STR)

func _before_instance_change() -> void:
	if instance:
		instance.property_changed.disconnect(_on_instance_property_changed)

func _on_instance_changed(new_instance:ItemInstance) -> void:
	new_instance.property_changed.connect(_on_instance_property_changed)
	filtered_gun_ref = new_instance.item_reference

func _on_instance_property_changed(key:StringName) -> void:
	match key:
		filtered_gun_ref.PROPERTY_LOADED_AMMO_TYPE_STR:
			loaded_ammo = instance.get_property(filtered_gun_ref.PROPERTY_LOADED_AMMO_TYPE_STR)
		filtered_gun_ref.PROPERTY_LOADED_AMMO_AMOUNT_STR:
			loaded_ammo_amount_changed.emit()

func _get_available_ammo(loaded_type_only:bool = false) -> Array[ItemInstance]:
	var returned_ammo:Array[ItemInstance] = []
	var filter = null
	if loaded_type_only and loaded_ammo:
		filter = ItemIdFilter.new()
		var accepted_items:Array[ItemReference] = [loaded_ammo]
		filter.accepted_items = accepted_items
	else:
		filter = AmmoFilter.new()
		var allowed_ammo_families:Array[AmmoItem.Family] = [filtered_gun_ref.ammo_family]
		filter.allowed_ammo_families = allowed_ammo_families
	returned_ammo = holder.parent_entity.ammo_inventory.get_content(filter)
	return returned_ammo
