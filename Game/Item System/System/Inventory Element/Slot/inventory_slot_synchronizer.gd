extends Node
class_name InventorySlotSynchronizer

## Dirty workaround
@export var _synchronized_slot:InventorySlot

var synchronized_slot:InventorySlot:
	set(new):
		if synchronized_slot:
			if is_multiplayer_authority():
				synchronized_slot.item_switched.disconnect(_on_server_item_switched)
		synchronized_slot = new
		if synchronized_slot:
			if is_multiplayer_authority():
				synchronized_slot.item_switched.connect(_on_server_item_switched)

@export var synchronizer:MultiplayerSynchronizer

@export var synchronized_item_uid:String = "":
	set(new):
		synchronized_item_uid = new
		if !is_inside_tree():
			return
		if !multiplayer.is_server():
			if is_multiplayer_authority():
				return
			if !synchronized_item_uid:
				synchronized_slot.held_item = null
			var resource = Items.get_item_by_id(synchronized_item_uid)
			if !resource:
				return
			synchronized_slot.held_item = ItemInstance.from_resource(resource)

@export var synchronized_item_properties:Dictionary = {}:
	set(new):
		synchronized_item_properties = new
		if !is_inside_tree():
			return
		if is_multiplayer_authority():
			return
		if !synchronized_slot.held_item:
			return
		synchronized_slot.held_item.update_properties(synchronized_item_properties)

var slot_item_instance:ItemInstance:
	set(new):
		if slot_item_instance:
			slot_item_instance.properties_changed.disconnect(_on_slot_item_instance_properties_changed)
		slot_item_instance = new
		if slot_item_instance:
			slot_item_instance.properties_changed.connect(_on_slot_item_instance_properties_changed)
			synchronized_item_uid = slot_item_instance.item_reference.item_uid
			synchronized_item_properties = slot_item_instance.properties
		else:
			synchronized_item_uid = ""
			synchronized_item_properties = {}

func _on_slot_item_instance_properties_changed() -> void:
	if !slot_item_instance:
		return
	synchronized_item_properties = slot_item_instance.properties

func _on_server_item_switched(new_item:ItemInstance) -> void:
	if is_multiplayer_authority():
		slot_item_instance = new_item

func _ready() -> void:
	synchronized_slot = _synchronized_slot
	if is_multiplayer_authority():
		_on_server_item_switched(synchronized_slot.held_item)
