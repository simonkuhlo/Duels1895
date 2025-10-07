@tool
extends Control
class_name VirtualCursor

@export var max_radius:float = 200

@export_group("UI")
@export var max_radius_indicator_color: Color = Color.RED
@export var cursor_color:Color = Color.RED
@export var max_radius_indicator_width: float = 3
@export var max_radius_visible:bool = true
@export var cursor_visible:bool = true

@export_group("Auto Retract")
@export var auto_retract:bool = false
@export var auto_retract_speed:float = 1000
@export var auto_retract_delay:float = 0.5

@export_group("Linking")
@export var auto_retract_timer:Timer

var active:bool = true:
	set(new):
		active = new
		reset()

var cursor_pos:Vector2 = Vector2.ZERO:
	set(new):
		cursor_pos = new
	get():
		return cursor_pos

func reset() -> void:
	cursor_pos = Vector2.ZERO

func _process(delta: float) -> void:
	queue_redraw()
	if auto_retract:
		if auto_retract_timer.is_stopped():
			cursor_pos = cursor_pos.move_toward(Vector2.ZERO, delta * auto_retract_speed)

func _draw() -> void:
	if max_radius_visible:
		draw_arc(Vector2.ZERO, max_radius, 0, TAU, 2 * max_radius, max_radius_indicator_color, max_radius_indicator_width)
	if cursor_visible:
		draw_arc(cursor_pos, 24, 0, TAU, 40, cursor_color, 2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var rel = event.relative
		cursor_pos += rel
		var center_point = Vector2.ZERO
		var offset = cursor_pos - center_point
		if offset.length() > max_radius:
			offset = offset.normalized() * max_radius
			cursor_pos = center_point + offset
		if auto_retract:
			auto_retract_timer.start(auto_retract_delay)
