extends Node2D


var selected_tower: int = 0

@export var map: Map

@export var board_camera: BoardCamera

@export var ready_count: Label

@export var start_button: Button

@export var towers_containter: HBoxContainer

@onready var towers_available: Dictionary = map.towers.duplicate()


func _ready() -> void:
	board_camera.map = map
	
	if multiplayer.is_server():
		uncheck_players_ready()
	
	refresh_towers_button()
	refresh_ready_players()
	
	Players.infos_changed.connect(refresh_ready_players)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			toggle_tower(get_global_mouse_position())


func uncheck_players_ready() -> void:
#	var infos_copy = Players.infos.duplicate(true)
	
	for info in Players.infos.values():
		info["is_ready"] = false
	
	Players.update_infos.rpc(Players.infos, true)


func refresh_towers_button() -> void:
	clear_towers_button()
	
	for id in towers_available:
		var quantity_available: int = towers_available[id]
		
		if quantity_available > 0:
			var button: Button = Button.new()
			
			button.text = str(quantity_available)
			button.icon = Towers.get_tower_texture(id)
			button.add_theme_font_size_override("font_size", 64)
			button.pressed.connect(func(): selected_tower = id)
			
			towers_containter.add_child(button)


func clear_towers_button() -> void:
	for child in towers_containter.get_children():
		child.queue_free()


func toggle_tower(global_pos: Vector2) -> void:
	var player_id: int = multiplayer.get_unique_id()
	var buildboard: Buildboard = map.build_map.get_buildboard(player_id)
	var local_pos: Vector2 = buildboard.to_local(global_pos)
	
	# Can't build towers in this position.
	if buildboard.is_pos_empty(local_pos):
		return
	
	(
		build_tower(selected_tower, local_pos, player_id)
		or map.build_map.destroy_tower(local_pos, player_id)
	)


@rpc("authority", "call_local", "reliable")
func build_tower(tower_id: int, local_pos: Vector2, player_id: int) -> bool:
	if player_id == multiplayer.get_unique_id() and towers_available.get(tower_id, 0) <= 0:
		return false
	
	var tower: Tower = Towers.get_tower(tower_id)
	
	if player_id == multiplayer.get_unique_id():
		tower.tree_entered.connect(update_towers_available.bind(tower_id, -1))
		tower.tree_exiting.connect(update_towers_available.bind(tower_id, 1))
	
	var built: bool = map.build_map.build_tower(tower, local_pos, player_id)
	
	if not built:
		tower.queue_free()
	
	return built


func update_towers_available(tower_id: int, value: int) -> void:
	towers_available[tower_id] += value
	refresh_towers_button()


func refresh_ready_players() -> void:
	var counter: int = 0
	
	for info in Players.infos.values():
		if info["is_ready"]:
			counter += 1
	
	ready_count.text = "%s/%s" % [counter, map.get_max_players()]
	start_button.visible = multiplayer.is_server() and counter == map.get_max_players()


@rpc("authority", "call_remote", "reliable")
func request_towers_positions() -> void:
	var towers_src = map.build_map.towerboard.towers
	var towers = {}
	
	for pos in map.build_map.towerboard.towers:
		var tower: Tower = towers_src[pos]
		towers[pos] = tower.IDENTIFIER
	
	build_player_towers.rpc_id(1, towers)


@rpc("any_peer", "call_remote", "reliable")
func build_player_towers(towers: Dictionary, is_recursion: bool = false) -> void:
	var player_id: int = multiplayer.get_remote_sender_id()
	var player_towers_available: Dictionary = map.towers.duplicate()
	
	for pos in towers:
		var tower: int = towers[pos]
		var qty: int = player_towers_available[tower]
		var local_pos: Vector2 = map.build_map.get_buildboard(player_id).map_to_local(pos)
		
		if qty > 0:
			build_tower.rpc(tower, local_pos, player_id)
			player_towers_available[tower] = qty - 1
	
	Players.infos[player_id]["towers_sent"] = true
	
	if Players.are_towers_sent() and not is_recursion:
		build_server_towers()


func build_server_towers() -> void:
	# Same logic from request_towers_positions()
	var towers_src = map.build_map.towerboard.towers
	var towers = {}
	
	for pos in map.build_map.towerboard.towers:
		var tower: Tower = towers_src[pos]
		towers[pos] = tower.IDENTIFIER
	
	# Same logic from build_player_towers()
	var player_towers_available: Dictionary = map.towers.duplicate()
	
	for pos in towers:
		var tower: int = towers[pos]
		var qty: int = player_towers_available[tower]
		var local_pos: Vector2 = map.build_map.get_buildboard(1).map_to_local(pos)
		
		if qty > 0:
			build_tower.rpc(tower, local_pos, 1)
			player_towers_available[tower] = qty - 1


func start_game() -> void:
	remove_child(map) # hold the map


func _on_check_button_toggled(button_pressed: bool) -> void:
	Players.update_info.rpc({"is_ready": button_pressed})


func _on_start_button_pressed() -> void:
	Players.infos[multiplayer.get_unique_id()]["towers_sent"] = true
	request_towers_positions.rpc()
