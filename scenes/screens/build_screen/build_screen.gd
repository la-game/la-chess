extends Node2D


var selected_tower: int = 0

@export var map: Map

@export var towers_containter: HBoxContainer

@export var ready_count: Label

@onready var towers_available: Dictionary = map.towers.duplicate()


func _ready() -> void:
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


func _on_check_button_toggled(button_pressed: bool) -> void:
	Players.update_info.rpc({"is_ready": button_pressed})
