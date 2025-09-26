extends Node3D
class_name MapInstance

signal controlled_entity_changed(new_entity:EntityBody3D)
signal pause_state_changed(new_state:bool)

@export var player_spawns:Array[PlayerSpawner]

var controlled_entity:EntityBody3D:
	set(new):
		controlled_entity = new
		controlled_entity_changed.emit(controlled_entity)

var peer_entity_mapping:Dictionary[int, EntityBody3D]

var paused:bool:
	set(new):
		paused = new
		if paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		pause_state_changed.emit(paused)

func start_game() -> void:
	if !multiplayer.is_server():
		return
	for peer in MapLoader.loaded_peers:
		player_spawns[0].spawn_player(peer)
	paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		paused = !paused
