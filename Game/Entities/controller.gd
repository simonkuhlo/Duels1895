extends Node
class_name BasePlayerCharacterController


@export var gravity:float = 9.81
@export var sprint_stamina_consumption_per_second:float = 1
@export var jump_stamina_consumption = 10
@export var air_control:float = 5
@export var sprint_speed_modifier = 0.2


@export var controlled_entity:PlayerCharacterBody3D
@export var look_sensitivity:float = 0.005

func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return
	if event is InputEventMouseMotion:
		# Rotate the player (yaw) and camera (pitch)
		controlled_entity.rotate_y(-event.relative.x * look_sensitivity)
		controlled_entity.neck.rotate_x(-event.relative.y * look_sensitivity)
		# Clamp the neck's rotation to prevent flipping
		controlled_entity.neck.rotation.x = clamp(controlled_entity.neck.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _on_controlled_entity_physics_process(delta: float) -> void:
	var input_vector: Vector2 = _get_input_vector()
	var direction = Vector3.ZERO
	# Get the camera's basis if you want camera-relative movement; otherwise use controlled_entity.global_transform.basis.
	var forward = -controlled_entity.global_transform.basis.z
	var right = controlled_entity.global_transform.basis.x
	direction += forward * input_vector.y
	direction += right * input_vector.x
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	var move_speed:float = controlled_entity.move_speed.current_value
	if controlled_entity.is_on_floor():
		controlled_entity.velocity.y = 0
		if Input.is_action_pressed("sprint"):
			if direction:
				move_speed = _sprint(delta)
		controlled_entity.velocity.x = direction.x * move_speed
		controlled_entity.velocity.z = direction.z * move_speed
		if Input.is_action_just_pressed("jump"):
			controlled_entity.velocity.y = _jump()
	else:
		controlled_entity.velocity.x = lerp(controlled_entity.velocity.x, direction.x * move_speed, air_control * delta)
		controlled_entity.velocity.z = lerp(controlled_entity.velocity.z, direction.z * move_speed, air_control * delta)
		controlled_entity.velocity.y -= gravity * delta
	controlled_entity.move_and_slide()

func _get_input_vector() -> Vector2:
	var return_vector:Vector2 = Vector2.ZERO
	return_vector = Input.get_vector("move_forward", "move_backward", "move_left", "move_right")
	return return_vector.normalized()

func _jump() -> float:
	var current_stamina:float = controlled_entity.movement_stamina.current_value
	var jump_strength:float = controlled_entity.jump_strength.current_value
	if current_stamina < jump_stamina_consumption:
		jump_strength = jump_strength * 0.5
	else:
		controlled_entity.movement_stamina.current_value -= jump_stamina_consumption
	return jump_strength

func _sprint(delta:float) -> float:
	var move_speed:float = controlled_entity.move_speed.current_value
	var speed_modifier = sprint_speed_modifier
	var current_stamina:float = controlled_entity.movement_stamina.current_value
	if current_stamina < sprint_stamina_consumption_per_second * delta:
		speed_modifier *= 0.5
	controlled_entity.movement_stamina.current_value -= sprint_stamina_consumption_per_second * delta
	move_speed += move_speed * speed_modifier
	return move_speed
	
