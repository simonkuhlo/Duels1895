extends RayCast3D
class_name BulletInstance

func _physics_process(delta: float) -> void:
	var ray_cast:RayCast3D = RayCast3D.new()
	var pos_next:Vector3 = calculate_next_position(delta)
	target_position = pos_next - global_transform.origin
	var collider = get_collider()
	if collider:
		collide(collider)
	global_transform.origin = pos_next
	print(transform.origin)

func calculate_next_position(delta:float) -> Vector3:
	return global_transform.origin + Vector3.FORWARD * 10 * delta

func collide(collider:Object) -> void:
	pass
