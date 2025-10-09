extends Node3D
class_name EquippedItem

var instance:ItemInstance:
	set(new):
		_before_instance_change()
		instance = new
		_on_instance_changed(instance)

var holder:ItemHolder3D:
	set(new):
		holder = new
		if holder:
			set_multiplayer_authority(holder.get_multiplayer_authority())

@export var animation_tree:AnimationTree

func _on_instance_changed(new_instance:ItemInstance) -> void:
	pass

func _before_instance_change() -> void:
	pass
