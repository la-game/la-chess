extends Node


## Emitted when the map change.
signal map_changed

## Emitted when the order of player change.
signal order_changed

## Emitted when the turn change.
signal turn_changed

## Emitted when the match ends.
signal match_ended

## The current map from the match.
var map: Map

## Defines who goes first, second, third, etc.
var order: Array

## Current turn
var turn: int = 0


func _ready() -> void:
	reset()
	
	turn_changed.connect(_on_turn_changed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


## Reset the match, setting the default values back.
func reset() -> void:
	order = [1] # The server
	turn = 0


## Get the player of the current turn.
func get_turn_player() -> int:
	return order[turn % order.size()]


## Get the floorboard used for this match.
func get_floorboard() -> Floorboard:
	return map.battle_map.floorboard


## Get the towerboard used for this match.
func get_towerboard() -> Towerboard:
	return map.battle_map.towerboard


## Finish the building stage.
## [br]Should be called after all players being ready.
@rpc("authority", "call_local", "reliable")
func finish_building() -> void:
	map.build_map.disable()


## Finish the turn.
## [br]Only the server can finish it and should only call it
## after the player move.
@rpc("authority", "call_local", "reliable")
func finish_turn() -> void:
	turn += 1
	turn_changed.emit()


## Set the current map.
## [br]This is not an instance of the map, but the string which should instanciate the scene.
@rpc("authority", "call_local", "reliable")
func set_map(new_map: String) -> void:
	map = load(new_map).instance() as Map
	map_changed.emit()


## Set the order for all players.
@rpc("authority", "call_local", "reliable")
func set_order(new_order: Array) -> void:
	order = new_order
	order_changed.emit()


func _on_turn_changed() -> void:
	var player_id: int = get_turn_player()
	var is_king_alive: bool = get_towerboard().is_king_alive(player_id)
	
	if get_towerboard().kings_remaining() <= 1:
		match_ended.emit()
	elif not get_towerboard().is_king_alive(player_id):
		finish_turn.rpc()


func _on_peer_connected(id: int) -> void:
	if multiplayer.is_server():
		order.append(id)
		set_order.rpc(order)


func _on_peer_disconnected(id: int) -> void:
	order.erase(id)
	order_changed.emit()
