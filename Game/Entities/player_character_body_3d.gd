extends EntityBody3D
class_name PlayerCharacterBody3D

@export_group("Linking")
@export var action_stamina:EntityStatHolder
@export var movement_stamina:EntityStatHolder
@export var ads_stamina:EntityStatHolder
<<<<<<< Updated upstream
@export var controller:Node
=======
@export var jump_strength:EntityStatHolder
@export var controller:BasePlayerCharacterController:
	set(new):
		controller = new
		if controller:
			controller.controlled_entity = self

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		if controller:
			controller._on_controlled_entity_physics_process(delta)
>>>>>>> Stashed changes
