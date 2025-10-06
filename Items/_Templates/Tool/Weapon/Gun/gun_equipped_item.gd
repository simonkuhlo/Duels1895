extends EquippedWeapon
class_name EquippedGun

var loaded_ammo_amount:int = 1:
	set(new):
		loaded_ammo_amount = new

@export var loaded_ammo:AmmoItem

var filtered_gun_item:GunItem:
	set(new):
		filtered_gun_item = new
		if !loaded_ammo:
			loaded_ammo = filtered_gun_item.default_ammo

@export var bullet_scene:PackedScene

func _on_instance_changed(new_instance:ItemInstance) -> void:
	filtered_gun_item = new_instance.item_reference

func _get_available_ammo(loaded_type_only:bool = false) -> Array[ItemInstance]:
	var returned_ammo:Array[ItemInstance] = []
	var filter = null
	if loaded_type_only:
		filter = ItemIdFilter.new()
		filter.accepted_items = [loaded_ammo]
	else:
		filter = AmmoFilter.new()
		filter.allowed_ammo_families = [filtered_gun_item.ammo_family]
	returned_ammo = holder.parent_entity.ammo_inventory.get_content(filter)
	return returned_ammo

func _on_idle_activated() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Idle")

func _on_aiming_activated() -> void:
	pass

func _on_shooting_activated() -> void:
	if is_multiplayer_authority():
		_request_shoot.rpc_id(1, holder.parent_entity.neck.global_transform)
		_on_shooting_activated_rpc.rpc()

@rpc("authority", "call_local", "reliable")
func _on_shooting_activated_rpc() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Shoot")

func _on_reloading_activated() -> void:
	if is_multiplayer_authority():
		_on_reloading_activated_rpc.rpc()

@rpc("authority", "call_local", "reliable")
func _on_reloading_activated_rpc():
	if multiplayer.is_server():
		var inventory_ammo = _get_available_ammo(true)
		if !inventory_ammo:
			return
		var missing_amount = filtered_gun_item.magazine_size - loaded_ammo_amount
		var added_amount = min(missing_amount, inventory_ammo[0].amount)
		loaded_ammo_amount += added_amount
		inventory_ammo[0].amount -= added_amount
	animation_tree["parameters/playback"].travel("TestGun_Reload")

@rpc("authority", "call_local", "reliable")
func _request_shoot(origin:Transform3D):
	if !multiplayer.is_server():
		return
	if multiplayer.get_remote_sender_id():
		if multiplayer.get_remote_sender_id() != get_multiplayer_authority():
			return
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
	damage_source.weapon = filtered_gun_item
	bullet_instance.current_velocity = filtered_gun_item.base_velocity * loaded_ammo.velocity_modifier
	bullet_instance.current_damage = filtered_gun_item.base_damage * loaded_ammo.damage_modifier
	bullet_instance.damage_source = damage_source
	bullet_instance.global_transform = origin
	MapLoader.loaded_map_instance.add_child(bullet_instance, true)
