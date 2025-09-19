extends Control
class_name InventoryVisualizer

@export var slot_visualizer_scene:PackedScene
@export var slot_visualizer_root:Control = self

var represented_inventory:Inventory:
	set(new):
		if represented_inventory:
			represented_inventory.slots_changed.disconnect(visualize_slots)
		represented_inventory = new
		if represented_inventory:
			represented_inventory.slots_changed.connect(visualize_slots)
		visualize_slots()

func visualize_slots() -> void:
	for child in slot_visualizer_root.get_children():
		if child is InventorySlotVisualizer:
			child.queue_free()
	for slot in represented_inventory.slots:
		var visualizer_instance:InventorySlotVisualizer = slot_visualizer_scene.instantiate()
		visualizer_instance.represented_slot = slot
		slot_visualizer_root.add_child(visualizer_instance)
