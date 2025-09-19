extends EntityBody3D
class_name PlayerCharacterBody3D

@export_group("Linking")
@export var action_stamina:EntityStatHolder
@export var movement_stamina:EntityStatHolder
@export var ads_stamina:EntityStatHolder
@export var jump_strength:EntityStatHolder
@export var controller:BasePlayerCharacterController:
	set(new):
		controller = new
		if controller:
			controller.controlled_entity = self
@export var exclude_client_authority:Array[Node]

@export_group("UI hints")
@export var hotbar_inventory:Inventory

func _enter_tree() -> void:
	pass

func _ready() -> void:
	super._ready()
	_multiplayer_setup.call_deferred()

func _multiplayer_setup() -> void:
	if int(name) in MapLoader.loaded_peers:
		custom_set_multiplayer_authority(int(name))
		for node in exclude_client_authority:
			node.set_multiplayer_authority(1)
		if is_multiplayer_authority():
			fpv_camera.current = true

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		if controller:
			controller._on_controlled_entity_physics_process(delta)
