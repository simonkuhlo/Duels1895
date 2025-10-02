extends Area3D
class_name InteractionHurtbox

signal interaction_requested(entity:EntityBody3D)

func request_interaction(entity:EntityBody3D):
	interaction_requested.emit(entity)
