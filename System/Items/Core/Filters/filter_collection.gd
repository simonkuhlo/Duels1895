extends BaseFilter
class_name FilterCollection

enum Mode {ALL, ANY, NONE}

@export var mode:Mode = Mode.ALL
@export var filters:Array[BaseFilter]

func filter(item:Variant) -> bool:
	match mode:
		Mode.ALL:
			return mode_all(item)
		Mode.ANY:
			return mode_any(item)
		Mode.NONE:
			return mode_none(item)
	return false

func mode_all(item:Variant) -> bool:
	for filter_resource in filters:
		if !filter_resource.filter(item):
			return false
	return true

func mode_any(item:Variant) -> bool:
	for filter_resource in filters:
		if filter_resource.filter(item):
			return true
	return false

func mode_none(item:Variant) -> bool:
	for filter_resource in filters:
		if filter_resource.filter(item):
			return false
	return true
