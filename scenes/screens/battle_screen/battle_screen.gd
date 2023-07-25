extends Node2D


## Map loaded from BuildScreen
var map: Map

@export var board_camera: BoardCamera


func _ready() -> void:
	map = Match.map as Map
	
	# First add child to inherit the multiplayer property
	add_child(map)
	
	map.build_map.disable()
	map.battle_map.link_towers_to_click()



