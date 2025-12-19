extends RadialMenuOption
class_name RadialMenuItemOption

enum TextMode {ITEM_NAME, ITEM_AMOUNT, NONE}

@export var displayed_text:TextMode = TextMode.ITEM_NAME

@export var item_instance:ItemInstance:
	set(new):
		if item_instance:
			item_instance.changed.disconnect(_on_instance_changed)
		item_instance = new
		if item_instance:
			item_instance.changed.connect(_on_instance_changed)
		changed.emit()
		_on_instance_changed()

func update() -> void:
	_on_instance_changed()

func _on_instance_changed() -> void:
	if item_instance:
		icon = item_instance.item_reference.icon
		match displayed_text:
			TextMode.ITEM_NAME:
				text = item_instance.item_reference.item_name
			TextMode.ITEM_AMOUNT:
				text = str(item_instance.amount)
			_:
				text = ""
