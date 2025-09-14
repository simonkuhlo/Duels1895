extends Marker3D
class_name PlayerSpawner

@export var player_character_scene:PackedScene

@export var parent_map:MapInstance

func spawn_player(controlling_peer:int = 1) -> void:
	var character_instance:PlayerCharacterBody3D = player_character_scene.instantiate()
	character_instance.name = str(controlling_peer)
	character_instance.parent_world = parent_map
	character_instance.transform.origin = global_transform.origin
	parent_map.add_child(character_instance)
