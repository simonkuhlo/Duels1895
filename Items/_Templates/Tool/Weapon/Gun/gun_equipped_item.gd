extends EquippedWeapon
class_name EquippedGun


func _on_idle_activated() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Idle")

func _on_aiming_activated() -> void:
	pass

func _on_shooting_activated() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Shoot")

func _on_reloading_activated() -> void:
	animation_tree["parameters/playback"].travel("TestGun_Reload")
