extends CharacterBody3D
class_name EntityBody3D

signal authority_changed(new_authority:int)

@export_group("Linking")
@export var health:EntityStatHolder
@export var move_speed:EntityStatHolder
@export var fpv_camera:Camera3D
@export var tpv_camera:Camera3D
@export var neck:Node3D
@export var skin:MeshInstance3D
@export var item_holder:ItemHolder3D:
	set(new):
		if item_holder:
			item_holder.parent_entity = null
		item_holder = new
		if item_holder:
			item_holder.parent_entity = self
@export var inventories:InventoryCollection
@export var ammo_inventory:AmmoInventory

var parent_world:MapInstance = MapLoader.loaded_map_instance

func custom_set_multiplayer_authority(id:int, recursive:bool = true) -> void:
	set_multiplayer_authority(id, recursive)
	authority_changed.emit(id)

func _ready() -> void:
	authority_changed.connect(_on_authority_changed)

func _on_authority_changed(new_authority:int) -> void:
	if new_authority == multiplayer.get_unique_id():
		if parent_world:
			parent_world.controlled_entity = self
