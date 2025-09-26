extends TabContainer

@export var lobby_browser:Control
@export var lobby_visualizer:Control

func _ready() -> void:
	Lobby.lobby_entered.connect(_on_lobby_entered)
	Lobby.lobby_left.connect(_on_lobby_left)
	MapLoader.load_process_started.connect(_on_map_loader_load_process_started)
	MapLoader.map_cleared.connect(_on_map_loader_map_cleared)

func _on_map_loader_map_cleared() -> void:
	show()

func _on_map_loader_load_process_started() -> void:
	hide()

func _on_lobby_entered() -> void:
	lobby_visualizer.show()

func _on_lobby_left() -> void:
	lobby_browser.show()
