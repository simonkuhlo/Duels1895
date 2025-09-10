extends CanvasLayer

@export var health_bar:EntityStatVisualizer
@export var movement_stamina_bar:EntityStatVisualizer
@export var ads_stamina_bar:EntityStatVisualizer
@export var action_stamina_bar:EntityStatVisualizer

@export var controlled_entity:PlayerCharacterBody3D:
	set(new):
		controlled_entity = new
		if controlled_entity:
			health_bar.stat_to_represent = controlled_entity.health
			movement_stamina_bar.stat_to_represent = controlled_entity.movement_stamina
			ads_stamina_bar.stat_to_represent = controlled_entity.ads_stamina
			action_stamina_bar.stat_to_represent = controlled_entity.action_stamina
