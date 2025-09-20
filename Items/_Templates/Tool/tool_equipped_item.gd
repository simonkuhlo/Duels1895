extends EquippedItem
class_name EquippedTool

enum ActionTriggerMode {TOGGLE, HOLD}

var aim_mode:ActionTriggerMode = ActionTriggerMode.HOLD
var aiming:bool = false

func aim() -> void:
	pass

func _physics_process(delta: float) -> void:
	_process_aim_input()

func _process_aim_input() -> void:
	match aim_mode:
		ActionTriggerMode.TOGGLE:
			if Input.is_action_just_pressed("helditem_aim"):
				aiming = !aiming
		ActionTriggerMode.HOLD:
			if Input.is_action_pressed("helditem_aim"):
				aiming = true
			else:
				aiming = false


func _on_root_state_switched(old_state: Variant, new_state: Variant) -> void:
	print(new_state)
