## Responsible for the logic of towers battling each other.
class_name BattleMap
extends Node2D


## Emitted when the map detects a left click.
signal left_clicked(global_pos: Vector2)

## Floorboard responsible to know where the towers can exist.
@export var floorboard: Floorboard

## This Towerboard represents all towers, yours towers + enemies towers.
@export var towerboard: Towerboard

## Attackboard responsible to show the tiles that can be attacked.
@export var attackboard: Attackboard

## Moveboard responsible to show the tiles where the tower can move to.
@export var moveboard: Moveboard


func link_towers_to_click() -> void:
	for tower in towerboard.get_towers():
		if tower.player_id == multiplayer.get_unique_id():
			tower.left_clicked.connect(_on_tower_left_click)


func show_attack_tiles(attack_tiles: Array[Vector2i]) -> void:
	attack_tiles = floorboard.filter_empty_tiles(attack_tiles)
	attack_tiles = towerboard.filter_empty_tiles(attack_tiles)
	attackboard.clear_attack_tiles()
	attackboard.set_attack_tiles(attack_tiles)


func show_move_tiles(move_tiles: Array[Vector2i]) -> void:
	move_tiles = floorboard.filter_empty_tiles(move_tiles)
	move_tiles = towerboard.filter_used_tiles(move_tiles)
	move_tiles = attackboard.filter_used_tiles(move_tiles)
	moveboard.clear_move_tiles()
	moveboard.set_move_tiles(move_tiles)


@rpc("any_peer", "call_remote", "reliable")
func send_move(tower_tile: Vector2i, local_pos: Vector2) -> void:
	if not multiplayer.is_server():
		return
	
	if multiplayer.get_remote_sender_id() != Match.get_turn_player():
		return
	
	var tower: Tower = towerboard.towers[tower_tile]
	var players_except_sender: Array = Players.infos.keys().filter(
		func(k):
			return k != multiplayer.get_remote_sender_id()
	)
	
	if towerboard.move_tower(tower, local_pos):
		for player in players_except_sender:
			towerboard.request_move_tower.rpc_id(player, tower_tile, local_pos)
		Match.finish_turn.rpc()
	elif towerboard.attack_tower(tower, local_pos):
		for player in players_except_sender:
			towerboard.request_attack_tower.rpc_id(player, tower_tile, local_pos)
		Match.finish_turn.rpc()


func _on_tower_left_click(tower: Tower) -> void:
	var tile: Vector2i = towerboard.get_tower_tile(tower)
	
	show_attack_tiles(tower.get_attack_tiles(tile))
	show_move_tiles(tower.get_move_tiles(tile))
	
	if Match.get_turn_player() == multiplayer.get_unique_id():
		Phantom.new(tower, _on_phantom_released)


func _on_phantom_released(tower: Tower, global_pos: Vector2) -> void:
	attackboard.clear_attack_tiles()
	moveboard.clear_move_tiles()
	
	var local_pos: Vector2 = to_local(global_pos)
	var tower_tile: Vector2i = towerboard.get_tower_tile(tower)
	
	if towerboard.move_tower(tower, local_pos):
		if multiplayer.is_server():
			towerboard.request_move_tower.rpc(tower_tile, local_pos)
			Match.finish_turn.rpc()
		else:
			send_move.rpc_id(1, tower_tile, local_pos)
	elif towerboard.attack_tower(tower, local_pos):
		if multiplayer.is_server():
			towerboard.request_attack_tower.rpc(tower_tile, local_pos)
			Match.finish_turn.rpc()
		else:
			send_move.rpc_id(1, tower_tile, local_pos)
