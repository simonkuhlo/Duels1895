extends Control
class_name RadialMenu

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
@export var cursor:VirtualCursor

var selection_preview:int:
	set(new):
		selection_preview = new

func _draw() -> void:
	draw_circle(Vector2.ZERO, outer_radius, bkg_color)
	draw_arc(Vector2.ZERO, inner_radius, 0, TAU, 120, line_color, line_width)
	if options.size() <= 1:
		return
	if selection_preview == -1:
		draw_circle(Vector2.ZERO, inner_radius, highlight_color)
	for i in range(options.size()):
		var start_rads:float = TAU * i / options.size()
		var end_rads = TAU * (i+1) / options.size()
		var mid_rads = (start_rads + end_rads) / 2.0 * 1
		var radius_mid = (inner_radius + outer_radius) / 2
		
		if selection_preview == i:
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

func reset() -> void:
	if cursor:
		cursor.reset()

func update() -> void:
	queue_redraw()
	_visualize_options()

func select() -> void:
	if selection_preview == -1:
		option_selected.emit(null)
		return
	option_selected.emit(options[selection_preview])

func _visualize_options() -> void:
	for child in get_children():
		if child is RadialMenuOptionVisualizer:
			child.queue_free()
	for i in range(options.size()):
		var start_rads:float = TAU * i / options.size()
		var end_rads = TAU * (i+1) / options.size()
		var mid_rads = (start_rads + end_rads) / 2.0 * 1
		var radius_mid = (inner_radius + outer_radius) / 2
	
		var texture_origin := Vector2.from_angle(start_rads + (end_rads - start_rads) / 2)
		var texture_origin_radius:float = inner_radius + ( (outer_radius - inner_radius) / 2) 
		texture_origin = texture_origin * texture_origin_radius
		var visualizer_instance = option_visualizer.instantiate()
		visualizer_instance.position = texture_origin
		var reversed_options := options.duplicate()
		reversed_options.reverse()
		visualizer_instance.visualized_option = reversed_options[i]
		add_child(visualizer_instance)

func _ready() -> void:
	update()
	_visualize_options()

func _process(delta: float) -> void:
	if !visible:
		return
	var cursor_pos:Vector2
	if cursor:
		cursor_pos = cursor.cursor_pos
	else:
		cursor_pos = get_local_mouse_position()
	var cursor_radius = cursor_pos.length()
	
	if cursor_radius < inner_radius:
		selection_preview = -1
	else:
		var cursor_rads := fposmod(cursor_pos.angle() * -1, TAU)
		selection_preview = ceil((cursor_rads / TAU) * options.size()-1)
	queue_redraw()

func _input(event: InputEvent) -> void:
	if !visible:
		return
	if event is InputEventMouseMotion:
		pass

func add_option(option:RadialMenuOption) -> void:
	options.append(option)
	update()

func remove_option(option:RadialMenuOption) -> void:
	options.erase(option)
	update()

func overwrite_options(new_options:Array[RadialMenuOption]) -> void:
	options.clear()
	options = new_options
	update()
