extends Control
class_name RadialMenuOptionVisualizer

@export var texture_rect:TextureRect
@export var label:Label

@export var default_texture:Texture2D
@export var default_text:String = "?"

var visualized_option:RadialMenuOption:
	set(new):
		if visualized_option:
			visualized_option.changed.disconnect(_on_visualized_option_changed)
		visualized_option = new
		if visualized_option:
			visualized_option.changed.connect(_on_visualized_option_changed)
			visualized_option.update()
		_on_visualized_option_changed()

func _on_visualized_option_changed() -> void:
	if visualized_option:
		texture_rect.texture = visualized_option.icon
		label.text = visualized_option.text
	else:
		if default_texture:
			texture_rect.texture = default_texture
		else:
			texture_rect.texture = null
		label.text = default_text
