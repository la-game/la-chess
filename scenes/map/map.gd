class_name Map
extends Node2D


var IDENTIFIER: int = -1

## The map name, to be read by the player.
var NAME: String = "Undefined"

## Map a tower identifier to the quantity allowed in this map.
var towers: Dictionary = {}

@export var build_map: BuildMap

@export var battle_map: BattleMap


func get_max_players() -> int:
	return build_map.buildboards.size()


func get_board_size() -> Vector2:
	return build_map.floorboard.get_size()
