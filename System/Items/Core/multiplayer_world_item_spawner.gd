extends MultiplayerSpawner

func _ready() -> void:
	Items.item_db.changed.connect(setup)
	setup()

func setup() -> void:
	clear_spawnable_scenes()
	if Items.item_db.default_held_item_scene:
		add_spawnable_scene(Items.item_db.default_world_item_scene.resource_path)
	for item:ItemReference in Items.item_db.content.values():
		if item.world_item:
			add_spawnable_scene(item.world_item.resource_path)
