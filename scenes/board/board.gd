class_name Board
extends TileMap


var BOARD_ID: int = 0


## Get the map size in pixels.
func get_size() -> Vector2:
	return get_used_rect().size * tile_set.tile_size


## Remove all tiles from a specific layer.
func clear_tiles_on_layer(layer: int = 0) -> void:
	for tile in get_used_cells(layer):
		set_cell(layer, tile)


## Set a bunch of tiles to the same atlas tile.
func set_tiles_on_layer(tiles: Array[Vector2i], layer: int, board_id: int, atlas_tile: Vector2i) -> void:
	for tile in tiles:
		set_cell(layer, tile, board_id, atlas_tile)


## Returns a new array without the tiles that area already in use.
func filter_used_tiles(tiles: Array[Vector2i], layer: int = 0) -> Array[Vector2i]:
	return tiles.filter(
		func(t):
			return is_tile_empty(t, layer)
	)


## Returns a new array without the tiles that area empty.
func filter_empty_tiles(tiles: Array[Vector2i], layer: int = 0) -> Array[Vector2i]:
	return tiles.filter(
		func(t):
			return not is_tile_empty(t, layer)
	)


## Returns true if the position contains an empty tile.
func is_pos_empty(local_pos: Vector2, layer: int = 0) -> bool:
	return is_tile_empty(local_to_map(local_pos), layer)


## Returns true if the tile is empty.
func is_tile_empty(tile: Vector2i, layer: int = 0) -> bool:
	return get_cell_source_id(layer, tile) == -1
