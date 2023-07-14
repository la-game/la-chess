class_name Moveboard
extends Board


const MOVE_TILE: Vector2i = Vector2i(0,1)


func clear_move_tiles() -> void:
	clear_tiles_on_layer(0)


func set_move_tiles(tiles: Array[Vector2i]) -> void:
	set_tiles_on_layer(tiles, 0, BOARD_ID, MOVE_TILE)
