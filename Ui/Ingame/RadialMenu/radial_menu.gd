@tool
extends Control

@export var bkg_color:Color
@export var line_color:Color

@export var outer_radius:int = 300
@export var inner_radius:int = 64
@export var line_width:float = 4

@export var options:Array = []

func _draw() -> void:
	draw_circle(Vector2.ZERO, outer_radius, bkg_color)
	draw_arc(Vector2.ZERO, inner_radius, 0, TAU, 120, line_color, line_width)
	if options.size() <= 1:
		return
	for i in range(options.size()):
		var rads:float = TAU * i / options.size() - deg_to_rad(90)
		var origin = Vector2.from_angle(rads)
		draw_line(origin * inner_radius, origin * outer_radius, line_color, line_width)

func _process(delta: float) -> void:
	queue_redraw()
