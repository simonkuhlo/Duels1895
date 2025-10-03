extends Node3D
class_name BulletInstance

var damage_source:ProjectileDamageSource
var ammo_reference:AmmoItem
var current_velocity:float = 10

func _physics_process(delta: float) -> void:
	var pos_now: Vector3 = global_transform.origin
	var pos_next: Vector3 = calculate_next_position(delta)
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(pos_now, pos_next)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if result:
		var collider = result.collider
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
