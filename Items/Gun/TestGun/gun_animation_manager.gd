extends ItemAnimationManager
class_name GunAnimationManager

@export var animation_tree:AnimationTree

func ads() -> void:
	pass

@rpc("authority", "call_remote", "reliable")
func ads_rpc() -> void:
	pass

func shoot() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Shoot")

@rpc("authority", "call_remote", "reliable")
func shoot_rpc() -> void:
	pass

func reload() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Reload")

@rpc("authority", "call_remote", "reliable")
func reload_rpc() -> void:
	pass
