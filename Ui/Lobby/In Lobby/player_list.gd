extends PanelContainer

@export var visualizer_scene:PackedScene
@export var list_root:Control

var peer_visualizer_mapping:Dictionary[int, LobbyPeerVisualizer] = {}

func visualize_peer(peer:int) -> void:
	if peer in peer_visualizer_mapping.keys():
		peer_visualizer_mapping.get(peer).update()
	var instance:LobbyPeerVisualizer = visualizer_scene.instantiate()
	instance.peer_to_visualize = peer
	list_root.add_child(instance)
	peer_visualizer_mapping.set(peer, instance)

func _ready() -> void:
	Lobby.peer_profile_updated.connect(_on_profile_updated)
	Lobby.lobby_left.connect(reset)
	reset()

func reset() -> void:
	for visualizer in peer_visualizer_mapping.values():
		visualizer.queue_free()
	peer_visualizer_mapping.clear()
	for peer in Lobby.peer_profile_mapping.keys():
		visualize_peer(peer)

func _on_profile_updated(peer:int, profile:MultiplayerProfile) -> void:
	visualize_peer(peer)
