extends Node2D


var map: Map

@export var board_camera: BoardCamera


func _ready() -> void:
	load_map()


func load_map() -> void:
	map = Match.map
	map.build_map.disable()
	add_child(map)
