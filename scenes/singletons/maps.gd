extends Node


var all: Dictionary = {
	0: "res://prefabs/maps/chessboard/chessboard.tscn",
	1: "res://prefabs/maps/four_holes/four_holes.tscn",
	2: "res://prefabs/maps/big_square/big_square.tscn",
}


func get_map(id: int) -> Map:
	var map: Map = load(Maps.all[id]).instantiate()
	map.IDENTIFIER = id
	
	return map


func filter(method: Callable) -> Array[Map]:
	var result: Array[Map] = []
	
	for id in Maps.all:
		var map: Map = get_map(id)
		
		if method.call(map):
			result.append(map)
	
	return result
