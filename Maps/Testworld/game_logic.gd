extends Node
class_name GameLogic

@export var parent_world:MapInstance
@export var player_spawns:Array[PlayerSpawner]

func start_game() -> void:
	if !multiplayer.is_server():
		return
	for peer in MapLoader.loaded_peers:
		player_spawns[0].spawn_player(peer)
	parent_world.paused = false
