extends ProgressBar
class_name EntityStatVisualizer

var stat_to_represent:EntityStatHolder:
	set(new):
		if stat_to_represent:
			stat_to_represent.current_value_changed.disconnect(_on_current_value_changed)
		stat_to_represent = new
		if stat_to_represent:
			stat_to_represent.current_value_changed.connect(_on_current_value_changed)
			min_value = stat_to_represent.stat_to_represent.min_value
			max_value = stat_to_represent.stat_to_represent.max_value
			_on_current_value_changed(stat_to_represent.current_value)
			show()
		else:
			hide()

func _on_current_value_changed(new_value:float):
	value = new_value
