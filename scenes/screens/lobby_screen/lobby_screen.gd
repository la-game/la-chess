extends MarginContainer


@export var players_options: OptionButton

@export var map_options: OptionButton

@export var subviewport: SubViewport

@export var subviewport_map: Map

@export var start_button: Button


func _ready() -> void:
	if multiplayer.is_server():
		players_options.disabled = false
		map_options.disabled = false
		
		change_map_options(0)
		change_map_viewport(0)
		
		multiplayer.peer_connected.connect(_on_peer_connected)


@rpc("authority", "call_local", "reliable")
func change_map_options(index: int) -> void:
	var qty: int = int(players_options.get_item_text(index))
	var maps: Array[Map] = Maps.filter(
		func(map: Map):
			return map.get_max_players() == qty
	)
	
	map_options.selected = index # Do nothing for server
	map_options.clear()
	
	for map in maps:
		map_options.add_item(map.NAME, map.IDENTIFIER)


@rpc("authority", "call_local", "reliable")
func change_map_viewport(index: int) -> void:
	var id: int = map_options.get_item_id(index)
	var map: Map = Maps.get_map(id)
	var board_size: Vector2 = map.get_board_size()
	var ratio: float = subviewport.size.x / min(board_size.x, board_size.y)
	
	if subviewport_map:
		subviewport_map.queue_free()
	
	subviewport_map = map
	subviewport_map.scale = Vector2(ratio, ratio)
	subviewport.add_child(map)


func update_start_button() -> void:
	if multiplayer.is_server():
		var is_missing_players = subviewport_map.get_max_players() != Players.infos.size()
		start_button.disabled = is_missing_players or not Players.are_ready()


@rpc("authority", "call_local", "reliable")
func change_to_build_screen() -> void:
	Match.map = Maps.get_map(subviewport_map.IDENTIFIER)
	get_tree().change_scene_to_file("res://scenes/screens/build_screen/build_screen.tscn")


func _on_peer_connected(id: int) -> void:
	change_map_options.rpc_id(id, players_options.selected)
	change_map_viewport.rpc_id(id, map_options.selected)


func _on_players_options_item_selected(index: int) -> void:
	change_map_options.rpc(index)
	change_map_viewport.rpc(0)
	update_start_button()


func _on_map_options_item_selected(index: int) -> void:
	change_map_viewport.rpc(index)


func _on_check_button_toggled(button_pressed: bool) -> void:
	Players.update_info.rpc({"is_ready": button_pressed})


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/start_screen/start_screen.tscn")


func _on_lobby_players_players_changed() -> void:
	update_start_button()


func _on_start_button_pressed() -> void:
	change_to_build_screen.rpc()
