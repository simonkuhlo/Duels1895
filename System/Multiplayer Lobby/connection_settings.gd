extends Resource
class_name ConnectionSettings

@export var game_port:int = 6969
@export var used_profile:MultiplayerProfile = MultiplayerProfile.new()

@export_group("Server only")
@export var max_players:int = 10

@export_group("Client only")
@export var remote_address:String = "localhost"
