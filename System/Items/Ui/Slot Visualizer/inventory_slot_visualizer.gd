extends PanelContainer
class_name InventorySlotVisualizer

@export_group("Linking")
@export var icon_display:TextureRect
@export var amount_display:Label

var represented_slot:InventorySlot:
	set(new):
		if represented_slot:
			represented_slot.item_switched.disconnect(_on_represented_slot_item_switched)
		represented_slot = new
		if represented_slot:
			represented_slot.item_switched.connect(_on_represented_slot_item_switched)

var _mapped_item_instance:ItemInstance:
	set(new):
		if _mapped_item_instance:
			_mapped_item_instance.properties_changed.disconnect(_on_mapped_item_properties_changed)
		_mapped_item_instance = new
		if _mapped_item_instance:
			_mapped_item_instance.properties_changed.connect(_on_mapped_item_properties_changed)
			var icon_texture:Texture2D = _mapped_item_instance.item_reference.icon
			if !icon_texture:
				icon_texture = Items.item_db.default_icon
			icon_display.texture = icon_texture
		_on_mapped_item_properties_changed()

func _on_mapped_item_properties_changed() -> void:
	if !_mapped_item_instance:
		amount_display.text = ""
		return
	var current_amount := str(_mapped_item_instance.amount)
	var displayed_text:String = current_amount
	if _mapped_item_instance.item_reference.max_stack_size > 1:
		var max_amount := str(_mapped_item_instance.item_reference.max_stack_size)
		displayed_text += "/" + max_amount
	amount_display.text = displayed_text

func _on_represented_slot_item_switched(new_item:ItemInstance) -> void:
	_mapped_item_instance = new_item
