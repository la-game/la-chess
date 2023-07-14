extends Node


var all: Dictionary = {
	0: "res://prefabs/towers/king/king.tscn",
	1: "res://prefabs/towers/queen/queen.tscn",
	2: "res://prefabs/towers/knight/knight.tscn",
	3: "res://prefabs/towers/rook/rook.tscn",
	4: "res://prefabs/towers/bishop/bishop.tscn",
	5: "res://prefabs/towers/pawn/pawn.tscn",
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
