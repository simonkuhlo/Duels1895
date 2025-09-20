extends EquippedItem
class_name EquippedTool

enum ActionTriggerMode {TOGGLE, HOLD}

var aim_mode:ActionTriggerMode = ActionTriggerMode.HOLD
var aiming:bool = false

func _on_reloading_activated() -> void:
	animation_player.play("TestGun/reload")
	animation_player.queue("RESET")

func _on_idle_activated() -> void:
	animation_player.play("RESET")
	animation_player.queue("Idle")

func _on_aiming_processing(delta: Variant) -> void:
	print("aiming")

func _on_aiming_physics_processing(delta: Variant) -> void:
	print("aiming")

func _on_aiming_activated() -> void:
	print("aiming")

func _on_aiming_want_transition(transition: StateTransition) -> void:
	print(transition)
