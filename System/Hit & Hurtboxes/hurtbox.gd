extends Area3D
class_name Hurtbox

@export var damage_display:PackedScene


signal got_hit(damage_instance:DamageInstance)

func get_hit(damage_instance:DamageInstance) -> void:
	got_hit.emit(damage_instance)
	var damage_display_instance = damage_display.instantiate()
	damage_display_instance.damage_instance = damage_instance
	add_child(damage_display_instance)
