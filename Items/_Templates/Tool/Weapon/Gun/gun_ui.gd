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
@export var ammo_count_label:Label

var filtered_gun_instance:EquippedGun:
	set(new):
		if filtered_gun_instance:
			filtered_gun_instance.loaded_ammo_amount_changed.disconnect(_on_loaded_ammo_amount_changed)
		filtered_gun_instance = new
		if filtered_gun_instance:
			filtered_gun_instance.loaded_ammo_amount_changed.connect(_on_loaded_ammo_amount_changed)
			_on_loaded_ammo_amount_changed()

func _ready() -> void:
	filtered_gun_instance = parent_item

func _on_loaded_ammo_amount_changed() -> void:
	var new_amount = filtered_gun_instance.loaded_ammo_amount
	ammo_count_label.text = str(new_amount) + " / " + str(filtered_gun_instance.filtered_gun_ref.magazine_size)

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
				parent_item.reload()

func show_ammo_select() -> void:
	var ammo_select_options:Array[RadialMenuOption] = []
	for ammo_instance in filtered_gun_instance._get_available_ammo():
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
