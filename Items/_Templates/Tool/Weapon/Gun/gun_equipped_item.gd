extends EquippedWeapon
class_name EquippedGun

var loaded_ammo_amount:int = 1:
	set(new):
		loaded_ammo_amount = new
		print(loaded_ammo_amount)

var loaded_ammo:AmmoItem

var filtered_gun_item:GunItem:
	set(new):
		filtered_gun_item = new
		if !loaded_ammo:
			loaded_ammo = filtered_gun_item.default_ammo

@export var bullet_scene:PackedScene

func _on_instance_changed(new_instance:ItemInstance) -> void:
	filtered_gun_item = new_instance.item_reference

func _on_idle_activated() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Idle")

func _on_aiming_activated() -> void:
	pass

func _on_shooting_activated() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Shoot")
	if is_multiplayer_authority():
		_request_shoot(holder.parent_entity.neck.global_transform)

@rpc("authority", "call_local", "reliable")
func _on_reloading_activated() -> void:
	if multiplayer.is_server():
		loaded_ammo_amount = filtered_gun_item.magazine_size
	animation_tree["parameters/playback"].travel("TestGun_Reload")

@rpc("any_peer", "call_local", "reliable")
func _request_shoot(origin:Transform3D):
	if !multiplayer.is_server():
		if is_multiplayer_authority():
			_request_shoot.rpc_id(1, origin)
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
	MapLoader.loaded_map_instance.add_child(bullet_instance)
