extends Label3D

var damage_instance:DamageInstance:
	set(new):
		damage_instance = new
		text = "- " + str(damage_instance.damage)

func _process(delta: float) -> void:
	var scale_value = 50 + 5 * global_position.distance_to(MapLoader.loaded_map_instance.controlled_entity.global_position)
	font_size = scale_value
	self.global_position.y += 5 * delta

func _on_life_time_timeout() -> void:
	queue_free()
