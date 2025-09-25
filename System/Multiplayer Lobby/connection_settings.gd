extends Resource
class_name ConnectionSettings

enum ConnectionModes {ENET, ENET_DISCOVERY, WEBRTC, WEBSOCKET, SETAM}

@export var connection_mode = ConnectionModes.ENET
@export var game_port:int = 6969
@export var used_profile:MultiplayerProfile = MultiplayerProfile.new()
@export var discovery_server_address:String = "https://matchmaking.simonkuhlo.de"

@export_group("Server only")
@export var max_players:int = 10
@export var lobby_title:String = "New Lobby"
@export var lobby_password:String

@export_group("Client only")
@export var remote_address:String = "localhost"
