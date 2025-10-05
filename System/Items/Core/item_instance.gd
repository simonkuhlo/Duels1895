extends Resource
class_name ItemInstance

signal properties_changed()
signal request_sync()

@export var item_reference:ItemReference
var properties:Dictionary[StringName, Variant] = {"amount" = 1}
@export var amount:int:
	set(new):
		if item_reference.max_stack_size != 0:
			new = min(new, item_reference.max_stack_size)
		set_property("amount", new)
	get():
		return properties.get("amount", 0)

static func from_resource(resource:ItemReference) -> ItemInstance:
	var returned_instance = ItemInstance.new()
	returned_instance.item_reference = resource.duplicate()
	var custom_properties:Dictionary[StringName, Variant] = {}
	returned_instance.properties = resource.get_default_custom_properties()
	return returned_instance

func serialize_class() -> Dictionary:
	return {
		"id" = item_reference.id,
		"name" = item_reference.item_name,
		"properties" = properties
	}

func serialize_properties() -> Dictionary:
	return properties

func update_properties(dict:Dictionary) -> void:
	if properties == dict:
		return
	properties = dict
	properties_changed.emit()
	changed.emit()

func set_property(key:StringName, value) -> void:
	properties[key] = value
	properties_changed.emit()
	changed.emit()

## Creates a new item instance from a serialized one
static func deserialize(dict:Dictionary) -> ItemInstance:
	if !dict.has("id"):
		return
	var new_instance = ItemInstance.new()
	new_instance.item_reference = Items.get_item_by_id(dict["id"])
	new_instance.properties = dict["properties"]
	return new_instance
