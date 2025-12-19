extends Node
class_name MultiplayerMapLoader

signal map_loaded(map:MapResource)
signal load_process_started()
signal map_cleared()
signal loaded_peers_changed(loaded_peers:Array[int])

@export var map_db:MapDB
@export var map_instance_root:Node

@export_group("Networking only")
@export var awaited_peers:Array[int] = []
@export var loaded_peers:Array[int] = []

var loaded_map:MapResource:
	set(new):
		loaded_map = new
		if !loaded_map:
			map_cleared.emit()
		map_loaded.emit(loaded_map)

var loaded_map_instance:MapInstance

func initialize_load_process(map_to_load:MapResource) -> void:
	if !multiplayer.is_server():
		return
	#TODO validity checks here
	#is map in db?
	#are map max players enough?
	loaded_map = null
	if loaded_map_instance:
		loaded_map_instance.queue_free()
	loaded_map_instance = null
	awaited_peers.clear()
	awaited_peers = Lobby.accepted_peers.duplicate()
	print("Load process initialized: ", awaited_peers)
	var awaited_peers_temp:Array[int] = awaited_peers.duplicate()
	for peer in awaited_peers_temp:
		load_map_rpc.rpc_id(peer, map_to_load.uid)

@rpc("authority", "call_local", "reliable")
func load_map_rpc(map_id:StringName) -> void:
	var map:MapResource = map_db.get_map(map_id)
	if !map:
		load_map_response.rpc_id(1, false)
		return
	load_map(map)

@rpc("any_peer", "call_local", "reliable")
func load_map_response(success:bool) -> void:
	if !multiplayer.is_server():
		return
	var peer:int = multiplayer.get_remote_sender_id()
	print("Peer finished loading: ", str(peer))
	awaited_peers.erase(peer)
	if success:
		loaded_peers.append(peer)
		loaded_peers_changed.emit(loaded_peers)
	if awaited_peers.is_empty():
		on_load_process_finished()

func on_load_process_finished() -> void:
	if !multiplayer.is_server():
		return
	loaded_map_instance.game_logic.start_game()

func load_map(map:MapResource) -> void:
	load_process_started.emit()
	var instance:MapInstance = map.map_scene.instantiate()
	map_instance_root.add_child(instance)
	loaded_map_instance = instance
	loaded_map = map
	load_map_response.rpc_id(1, true)
