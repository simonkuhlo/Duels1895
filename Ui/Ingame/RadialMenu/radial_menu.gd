@tool
extends Control

signal option_selected(option:RadialMenuOption)

const sprite_size = Vector2(32, 32)

@export var bkg_color:Color
@export var line_color:Color
@export var highlight_color:Color

@export var outer_radius:int = 300
@export var inner_radius:int = 64
@export var line_width:float = 4

@export var options:Array[RadialMenuOption] = []

@export var option_visualizer:PackedScene

var selection:int:
	set(new):
		selection = new
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, outer_radius, bkg_color)
	draw_arc(Vector2.ZERO, inner_radius, 0, TAU, 120, line_color, line_width)
	if options.size() <= 1:
		return
	for i in range(options.size()):
		if !options[i]:
			continue
		var start_rads:float = TAU * (i-1) / options.size() - 1 - deg_to_rad(90)
		var end_rads = TAU * i / options.size() - 1 - deg_to_rad(90)
		var mid_rads = (start_rads + end_rads) / 2.0 * 1
		var radius_mid = (inner_radius + outer_radius) / 2
		
		if selection == i:
			var points_per_arc := 32
			var points_inner := PackedVector2Array()
			var points_outer := PackedVector2Array()
			for j in range(points_per_arc + 1):
				var angle = start_rads + j * (end_rads - start_rads) / points_per_arc
				points_inner.append(inner_radius * Vector2.from_angle(TAU-angle))
				points_outer.append(outer_radius * Vector2.from_angle(TAU-angle))
			points_outer.reverse()
			draw_polygon(points_inner + points_outer, PackedColorArray([highlight_color]))
		
		var line_origin := Vector2.from_angle(start_rads)
		draw_line(line_origin * inner_radius, line_origin * outer_radius, line_color, line_width)

func update() -> void:
	queue_redraw()
	_visualize_options()

func _ready() -> void:
	update()

func _visualize_options() -> void:
	for i in range(options.size()):
		if !options[i]:
			continue
		var start_rads:float = TAU * i / options.size() - deg_to_rad(90)
		var end_rads = TAU * (i+1) / options.size() - deg_to_rad(90)
		var texture_origin := Vector2.from_angle(start_rads + (end_rads - start_rads) / 2)
		var texture_origin_radius:float = inner_radius + ( (outer_radius - inner_radius) / 2) 
		texture_origin = texture_origin * texture_origin_radius
		var visualizer_instance = option_visualizer.instantiate()
		visualizer_instance.position = texture_origin
		visualizer_instance.visualized_option = options[i]
		add_child(visualizer_instance)

func _process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	var mouse_radius = mouse_pos.length()
	
	if mouse_radius < inner_radius:
		selection = -1
	else:
		var mouse_rads := fposmod(mouse_pos.angle() * -1, TAU)
		selection = ceil((mouse_rads / TAU) * options.size() - 1)
