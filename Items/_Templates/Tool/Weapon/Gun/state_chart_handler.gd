extends Node
class_name GunItemStateChartHandler

@export var parent_item:EquippedGun

func _on_idle_activated() -> void:
	parent_item.filtered_gun_animation_manager.idle()

func _on_aiming_activated() -> void:
	parent_item.filtered_gun_animation_manager.ads()

func _on_shooting_activated() -> void:
	parent_item.filtered_gun_animation_manager.shoot()
	parent_item.shoot(parent_item.holder.parent_entity.fpv_camera.global_transform)

func _on_reloading_activated() -> void:
	parent_item.filtered_gun_animation_manager.reload()
	parent_item.reload()
