extends Label3D

var damage_instance:DamageInstance:
	set(new):
		damage_instance = new
		text = "- " + str(damage_instance.damage)

func _process(delta: float) -> void:
	self.global_position.y += 5 * delta

func _on_life_time_timeout() -> void:
	queue_free()
