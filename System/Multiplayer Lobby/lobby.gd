extends Node
class_name GameLobby

signal lobby_entered()
signal lobby_left()

signal peer_profile_updated(peer:int, profile:MultiplayerProfile)

var accepted_peers:Array[int] = []
var peer_profile_mapping:Dictionary[int, MultiplayerProfile] = {}

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)

func create_server() -> void:
	var enet_peer = ENetMultiplayerPeer.new()
	var error = enet_peer.create_server(Settings.connection_settings.game_port, Settings.connection_settings.max_players)
	if error:
		leave_lobby(error)
		return
	multiplayer.multiplayer_peer = enet_peer
	request_profile_update_local(Settings.connection_settings.used_profile)
	accepted_peers.append(multiplayer.get_unique_id())
	lobby_entered.emit()

func create_client() -> void:
	var enet_peer = ENetMultiplayerPeer.new()
	var error = enet_peer.create_client(Settings.connection_settings.remote_address, Settings.connection_settings.game_port)
	if error:
		leave_lobby(error)
		return
	multiplayer.multiplayer_peer = enet_peer

func _on_connected_to_server() -> void:
	request_profile_update_local(Settings.connection_settings.used_profile)
	lobby_entered.emit()

func _on_peer_connected(id:int) -> void:
	if !multiplayer.is_server():
		return
	accepted_peers.append(id)
	for peer in peer_profile_mapping.keys():
		receive_profile_update.rpc_id(id, peer, peer_profile_mapping.get(peer).serialize())

func _on_peer_disconnected(id:int) -> void:
	peer_profile_mapping.erase(id)
	accepted_peers.erase(id)

func leave_lobby(error:Error = 1) -> void:
	peer_profile_mapping.clear()
	multiplayer.multiplayer_peer = null
	lobby_left.emit()

@rpc("authority", "call_local", "reliable")
func receive_profile_update(peer:int, serial_profile:Dictionary) -> void:
	var profile:MultiplayerProfile = MultiplayerProfile.deserialize(serial_profile)
	peer_profile_mapping.set(peer, profile)
	peer_profile_updated.emit(peer, profile)

func request_profile_update_local(profile:MultiplayerProfile) -> void:
	request_profile_update.rpc_id(1, profile.serialize())

@rpc("any_peer", "call_local", "reliable")
func request_profile_update(serial_profile:Dictionary) -> void:
	var peer:int = multiplayer.get_remote_sender_id()
	receive_profile_update.rpc(peer, serial_profile)
