@tool
extends Resource
class_name ItemInstance

signal properties_changed()
signal property_changed(key:StringName)
signal request_sync()

@export var item_reference:ItemReference:
	set(new):
		item_reference = new
		reset_properties()

@export var _properties:Dictionary[StringName, Variant] = {"amount" = 1}

@export var amount:int:
	set(new):
		if item_reference.max_stack_size != 0:
			new = min(new, item_reference.max_stack_size)
		set_property("amount", new)
	get():
		return _properties.get("amount", 0)

func _init() -> void:
	reset_properties()

func reset_properties() -> void:
	if item_reference:
		_properties = item_reference.get_default_custom_properties()
	if amount:
		_properties["amount"] = amount
	else:
		_properties["amount"] = 1
	properties_changed.emit()
	changed.emit()

static func from_resource(resource:ItemReference) -> ItemInstance:
	var returned_instance = ItemInstance.new()
	returned_instance.item_reference = resource
	return returned_instance

func serialize_class() -> Dictionary:
	return {
		"id" = item_reference.id,
		"name" = item_reference.item_name,
		"_properties" = _properties
	}

func serialize_properties() -> Dictionary:
	return _properties

func update_properties(dict:Dictionary) -> void:
	if _properties == dict:
		return
	_properties = dict
	properties_changed.emit()
	changed.emit()

func set_property(key:StringName, value) -> void:
	_properties[key] = value
	property_changed.emit(key)
	properties_changed.emit()
	changed.emit()

func get_property(key:StringName) -> Variant:
	return _properties.get(key)

## Creates a new item instance from a serialized one
static func deserialize(dict:Dictionary) -> ItemInstance:
	if !dict.has("id"):
		return
	var new_instance = ItemInstance.new()
	new_instance.item_reference = Items.get_item_by_id(dict["id"])
	new_instance._properties = dict["_properties"]
	return new_instance
