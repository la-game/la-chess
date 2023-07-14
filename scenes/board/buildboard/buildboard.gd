class_name Buildboard
extends Board


## Tile is free to build tower.
const FREE_TILE: Vector2i = Vector2i(2,0)

## Tile that is blocked and no tower can be build in it.
const BLOCK_TILE: Vector2i = Vector2i(3,0)

## Towers built from this buildboard will take this vector as front.
@export var front: Vector2i = Vector2i.UP


## Mark the tile at the position [code]local_pos[/code] as blocked, so no tower can be built there.
func block(local_pos: Vector2) -> bool:
	return block_tile(local_to_map(local_pos))


## Mark a tile as blocked, so no tower can be built there.
func block_tile(tile: Vector2i) -> bool:
	if get_cell_atlas_coords(0, tile) == FREE_TILE:
		set_cell(0, tile, BOARD_ID, BLOCK_TILE)
		return true
	return false


## Mark the tile at the position [code]local_pos[/code] as free, so a tower can be built there.
func unblock(local_pos: Vector2) -> bool:
	return unblock_tile(local_to_map(local_pos))


## Mark a tile as free, so a tower can be built there.
func unblock_tile(tile: Vector2i) -> bool:
	if get_cell_atlas_coords(0, tile) == BLOCK_TILE:
		set_cell(0, tile, BOARD_ID, FREE_TILE)
		return true
	return false
