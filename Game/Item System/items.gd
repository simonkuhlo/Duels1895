extends Node
class_name ItemSingleton

@export var item_db:ItemDB

func get_item_by_id(id:StringName) -> ItemReference:
	return item_db.content.get(id)
