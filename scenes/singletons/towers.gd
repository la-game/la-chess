extends Node


enum {
	KING,
	QUEEN,
	KNIGHT,
	ROOK,
	BISHOP,
	PAWN,
}

var all: Dictionary = {
	KING: "res://prefabs/towers/king/king.tscn",
	QUEEN: "res://prefabs/towers/queen/queen.tscn",
	KNIGHT: "res://prefabs/towers/knight/knight.tscn",
	ROOK: "res://prefabs/towers/rook/rook.tscn",
	BISHOP: "res://prefabs/towers/bishop/bishop.tscn",
	PAWN: "res://prefabs/towers/pawn/pawn.tscn",
}


func get_tower(id: int) -> Tower:
	var tower: Tower = load(all[id]).instantiate()
	tower.IDENTIFIER = id
	
	return tower


func get_tower_texture(id: int) -> Texture2D:
	var tower: Tower = get_tower(id)
	var texture: Texture2D = tower.texture
	
	tower.queue_free()
	return texture
