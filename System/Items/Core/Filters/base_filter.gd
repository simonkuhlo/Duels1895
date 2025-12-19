@tool
extends Resource
class_name BaseFilter

func _init() -> void:
	_defaults()

func filter(item:Variant) -> bool:
	return true

func _defaults() -> void:
	pass
