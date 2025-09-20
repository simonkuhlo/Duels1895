extends RigidBody3D
class_name WorldItem

@export var _held_slot:InventorySlot:
	set(new):
		if _held_slot:
			_held_slot.item_switched.disconnect(_on_held_slot_item_changed)
		_held_slot = new
		if _held_slot:
			_held_slot.item_switched.connect(_on_held_slot_item_changed)

@export var interaction_hurtbox:InteractionHurtbox:
	set(new):
		if interaction_hurtbox:
			interaction_hurtbox.interaction_requested.disconnect(on_player_interaction)
		interaction_hurtbox = new
		if interaction_hurtbox:
			interaction_hurtbox.interaction_requested.connect(on_player_interaction)

@export var collision_shape:CollisionShape3D

func on_player_interaction(player:EntityBody3D):
	_held_slot.transfer_content(player.inventories)

func _on_held_slot_item_changed(new_item:ItemInstance) -> void:
	if !is_inside_tree():
		return
	if !is_multiplayer_authority():
		return
	if !new_item:
		queue_free()

func _ready() -> void:
	authority_changed()

func authority_changed() -> void:
	if is_multiplayer_authority():
		set_deferred("freeze", false)  # Disables physics
		set_physics_process(true)
		set_process(true)
		collision_shape.disabled = false
	else:
		set_deferred("freeze", true)  # Disables physics
		set_physics_process(false)
		set_process(false)
		collision_shape.disabled = true

func _on_interaction_hurtbox_interaction_requested(entity: EntityBody3D) -> void:
	on_player_interaction(entity)
