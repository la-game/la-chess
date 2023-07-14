class_name Attackboard
extends Board


const ATTACK_TILE: Vector2i = Vector2i(1,1)


func clear_attack_tiles() -> void:
	clear_tiles_on_layer(0)


func set_attack_tiles(tiles: Array[Vector2i]) -> void:
	set_tiles_on_layer(tiles, 0, BOARD_ID, ATTACK_TILE)
