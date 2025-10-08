extends EquippedItemUI
class_name EquippedGunUI

@export var ammo_select_root:Control
@export var ammo_select:RadialMenu:
	set(new):
		if ammo_select:
			ammo_select.option_selected.disconnect(_on_ammo_selected)
		ammo_select = new
		if ammo_select:
			ammo_select.option_selected.connect(_on_ammo_selected)

@onready var filtered_gun_item:EquippedGun = parent_item

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select_ammo_type"):
		show_ammo_select()
	elif Input.is_action_just_released("select_ammo_type"):
		hide_ammo_select()

func _on_ammo_selected(option:RadialMenuOption) -> void:
	if option is RadialMenuItemOption:
		if option.item_instance.item_reference is AmmoItem:
			if parent_item is EquippedGun:
				parent_item.loaded_ammo = option.item_instance.item_reference

func show_ammo_select() -> void:
	var ammo_select_options:Array[RadialMenuOption] = []
	for ammo_instance in filtered_gun_item._get_available_ammo():
		var option := RadialMenuItemOption.new()
		option.item_instance = ammo_instance
		option.displayed_text = option.TextMode.ITEM_AMOUNT
		option.update()
		ammo_select_options.append(option)
	ammo_select.overwrite_options(ammo_select_options)
	ammo_select.reset()
	ammo_select_root.show()

func hide_ammo_select() -> void:
	ammo_select.select()
	ammo_select.reset()
	ammo_select_root.hide()
