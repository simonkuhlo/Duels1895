extends PanelContainer
class_name LobbyPeerVisualizer

@export var name_label:Label

var peer_to_visualize:int:
	set(new):
		peer_to_visualize = new
		update()

func update() -> void:
	var text = "NULL"
	var profile:MultiplayerProfile = Lobby.peer_profile_mapping.get(peer_to_visualize)
	if profile:
		text = profile.player_name
	name_label.text = text
