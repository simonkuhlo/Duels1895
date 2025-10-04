extends Node3D
class_name EquippedItem

var instance:ItemInstance:
	set(new):
		instance = new
		_on_instance_changed(instance)
var holder:ItemHolder3D

@export var animation_tree:AnimationTree

func _on_instance_changed(new_instance:ItemInstance) -> void:
	pass
