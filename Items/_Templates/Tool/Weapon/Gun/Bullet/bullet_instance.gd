extends Node3D
class_name BulletInstance

@export var damage_display:PackedScene

var damage_source:ProjectileDamageSource
var ammo_reference:AmmoItem
var current_damage:float = 10
var current_velocity:float = 200

var spawn_origin:Vector3

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
		var damage_instance:DamageInstance = DamageInstance.new()
		damage_instance.damage = current_damage
		damage_instance.source = damage_source
		collider.get_hit(damage_instance)
		queue_free()	
		var damage_display_instance = damage_display.instantiate()
		damage_display_instance.damage_instance = damage_instance
		damage_display_instance.global_transform = global_transform
		MapLoader.loaded_map_instance.add_child(damage_display_instance)
	if collider is PhysicsBody3D or collider is CSGShape3D:
		var damage_display_instance = damage_display.instantiate()
		damage_display_instance.text = "0"
		damage_display_instance.global_transform = global_transform
		MapLoader.loaded_map_instance.add_child(damage_display_instance)
		queue_free()

func _on_life_timer_timeout() -> void:
	queue_free()
