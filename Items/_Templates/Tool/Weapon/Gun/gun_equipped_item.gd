extends EquippedWeapon
class_name EquippedGun

@export var bullet_scene:PackedScene
var bullet_origin:Transform3D = Transform3D()

func _ready():
	bullet_origin = holder.parent_entity.neck.global_transform

func _on_idle_activated() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Idle")

func _on_aiming_activated() -> void:
	pass

func _on_shooting_activated() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Shoot")
	if is_multiplayer_authority():
		_request_shoot(bullet_origin)

func _on_reloading_activated() -> void:
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
	var bullet_instance:BulletInstance = bullet_scene.instantiate()
	bullet_instance.global_transform = origin
	MapLoader.loaded_map_instance.add_child(bullet_instance)
