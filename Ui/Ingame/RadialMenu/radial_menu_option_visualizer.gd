@tool
extends Control

@export var texture_rect:TextureRect
@export var label:Label

@export var default_texture:Texture2D
@export var default_text:String = "?"

var visualized_option:RadialMenuOption:
	set(new):
		visualized_option = new
		if visualized_option:
			texture_rect.texture = visualized_option.icon
			label.text = visualized_option.text
		else:
			if default_texture:
				texture_rect.texture = default_texture
			else:
				texture_rect.texture = null
			texture_rect.text = default_text
