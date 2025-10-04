extends Area3D
class_name Hurtbox

signal got_hit(damage_instance:DamageInstance)

func get_hit(damage_instance:DamageInstance) -> void:
	got_hit.emit(damage_instance)
