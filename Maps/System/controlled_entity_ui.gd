extends CanvasLayer

@export var health_bar:EntityStatVisualizer
@export var movement_stamina_bar:EntityStatVisualizer
@export var ads_stamina_bar:EntityStatVisualizer
@export var action_stamina_bar:EntityStatVisualizer
@export var hotbar_inventory_visualizer:HotbarInventoryVisualizer
@export var parent_world:MapInstance:
	set(new):
		if parent_world:
			parent_world.controlled_entity_changed.disconnect(_on_controlled_entity_changed)
		parent_world = new
		if parent_world:
			parent_world.controlled_entity_changed.connect(_on_controlled_entity_changed)

var controlled_entity:PlayerCharacterBody3D:
	set(new):
		controlled_entity = new
		if controlled_entity:
			health_bar.stat_to_represent = controlled_entity.health
			movement_stamina_bar.stat_to_represent = controlled_entity.movement_stamina
			ads_stamina_bar.stat_to_represent = controlled_entity.ads_stamina
			action_stamina_bar.stat_to_represent = controlled_entity.action_stamina
			hotbar_inventory_visualizer.represented_inventory = controlled_entity.inventories.inventories[0]
		else:
			health_bar.stat_to_represent = null
			movement_stamina_bar.stat_to_represent = null
			ads_stamina_bar.stat_to_represent = null
			action_stamina_bar.stat_to_represent = null
			hotbar_inventory_visualizer.represented_inventory = null

func _on_controlled_entity_changed(new_entity:EntityBody3D) -> void:
	controlled_entity = new_entity
