extends Node3D
class_name MapInstance

@export var player_spawns:Array[Marker3D]
@export var default_player_character:PackedScene

func start_game() -> void:
	if !multiplayer.is_server():
		return
	for peer in MapLoader.loaded_peers:
		var character_instance:PlayerCharacterBody3D = default_player_character.instantiate()
		character_instance.name = str(peer)
		character_instance.transform.origin = player_spawns[0].global_transform.origin
		add_child(character_instance)
		
	print("Game Started", MapLoader.loaded_peers)
