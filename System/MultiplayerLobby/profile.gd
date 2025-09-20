extends Resource
class_name MultiplayerProfile

signal name_changed(new_name:String)

const player_name_serial:String = "player_name"

@export var player_name:String = "Stranger":
	set(new):
		player_name = new
		name_changed.emit(player_name)
		changed.emit()

func serialize() -> Dictionary[StringName, Variant]:
	var return_dict:Dictionary[StringName, Variant] = {}
	return_dict.set(player_name_serial, player_name)
	return return_dict

static func deserialize(dict:Dictionary) -> MultiplayerProfile:
	var return_profile:MultiplayerProfile = MultiplayerProfile.new()
	return_profile.player_name = dict.get(player_name_serial, "Stranger")
	return return_profile
