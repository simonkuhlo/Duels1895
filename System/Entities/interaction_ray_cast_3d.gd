extends RayCast3D

@export var parent_entity:EntityBody3D

func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return
	if event.is_action_pressed("interact"):
		var collider = get_collider()
		if collider is InteractionHurtbox:
			collider.request_interaction(parent_entity)
