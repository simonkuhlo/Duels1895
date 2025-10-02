extends RayCast3D
class_name BulletInstance

var damage_source:ProjectileDamageSource
var ammo_reference:AmmoItem
var current_velocity:float = 200

func _physics_process(delta: float) -> void:
	var ray_cast:RayCast3D = RayCast3D.new()
	var pos_next:Vector3 = calculate_next_position(delta)
	target_position = pos_next - global_transform.origin
	var collider = get_collider()
	if collider:
		collide(collider)
	global_transform.origin = pos_next

func calculate_next_position(delta:float) -> Vector3:
	return global_position - global_transform.basis.z * current_velocity * delta

func collide(collider:Object) -> void:
	if collider is Hurtbox:
		collider.get_hit(DamageInstance.new())
		queue_free()

func _on_life_timer_timeout() -> void:
	queue_free()
