extends Node
class_name InventoryElement

signal uid_changed()

@export var uid:StringName:
	set(new):
		uid = new
		uid_changed.emit()

func _ready() -> void:
	if multiplayer.is_server():
		uid = Items.get_element_uid(self)

##Returns an ItemInstance containing the content this element did was not able to receive
func receive_item(item:ItemInstance) -> ItemInstance:
	return
