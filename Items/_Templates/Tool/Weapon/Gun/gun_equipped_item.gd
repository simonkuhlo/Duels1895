extends EquippedWeapon
class_name EquippedGun

signal loaded_ammo_changed()
signal loaded_ammo_amount_changed()

var filtered_gun_ref:GunItem
@export var filtered_gun_animation_manager:GunAnimationManager = self.animation_manager
@export var bullet_scene:PackedScene


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

func shoot(origin:Transform3D) -> void:
	if loaded_ammo_amount <= 0:
		return
	if !loaded_ammo:
		loaded_ammo_amount = 0
		return
	loaded_ammo_amount -= 1
	var bullet_instance:BulletInstance = bullet_scene.instantiate()
	var damage_source:ProjectileDamageSource = ProjectileDamageSource.new()
	damage_source.holder = holder.parent_entity
	damage_source.peer = multiplayer.get_remote_sender_id()
	damage_source.weapon = filtered_gun_ref
	bullet_instance.current_velocity = filtered_gun_ref.base_velocity * loaded_ammo.velocity_modifier
	bullet_instance.current_damage = filtered_gun_ref.base_damage * loaded_ammo.damage_modifier
	bullet_instance.damage_source = damage_source
	bullet_instance.global_transform = origin
	MapLoader.loaded_map_instance.add_child(bullet_instance, true)

@rpc("authority", "call_remote", "reliable")
func shoot_rpc(origin:Transform3D) -> void:
	if multiplayer.is_server():
		shoot(origin)

func reload() -> void:
	if !multiplayer.is_server():
		reload_rpc.rpc_id(1)
	var inventory_ammo = _get_available_ammo(true)
	if !inventory_ammo:
		return
	var missing_amount = filtered_gun_ref.magazine_size - loaded_ammo_amount
	var added_amount = min(missing_amount, inventory_ammo[0].amount)
	loaded_ammo_amount += added_amount
	inventory_ammo[0].amount -= added_amount
	filtered_gun_animation_manager.reload()

@rpc("authority", "call_remote", "reliable")
func reload_rpc() -> void:
	if multiplayer.is_server():
		reload()
