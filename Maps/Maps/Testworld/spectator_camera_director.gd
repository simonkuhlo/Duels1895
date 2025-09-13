extends Node3D

@export var scroll_speed:float = 7


func _physics_process(delta: float) -> void:
	rotate_y(deg_to_rad(scroll_speed*delta))
