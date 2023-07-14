extends Tower


func _init() -> void:
	NAME = "Queen"


func get_attack_tiles(tile: Vector2i) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	tiles.append_array(get_attack_tiles_in_direction(tile, Vector2i.UP))
	tiles.append_array(get_attack_tiles_in_direction(tile, Vector2i.DOWN))
	tiles.append_array(get_attack_tiles_in_direction(tile, Vector2i.RIGHT))
	tiles.append_array(get_attack_tiles_in_direction(tile, Vector2i.LEFT))
	tiles.append_array(get_attack_tiles_in_direction(tile, Vector2i(1, 1)))
	tiles.append_array(get_attack_tiles_in_direction(tile, Vector2i(1, -1)))
	tiles.append_array(get_attack_tiles_in_direction(tile, Vector2i(-1, 1)))
	tiles.append_array(get_attack_tiles_in_direction(tile, Vector2i(-1, -1)))
	return tiles


func get_move_tiles(tile: Vector2i) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	tiles.append_array(get_move_tiles_in_direction(tile, Vector2i.UP))
	tiles.append_array(get_move_tiles_in_direction(tile, Vector2i.DOWN))
	tiles.append_array(get_move_tiles_in_direction(tile, Vector2i.RIGHT))
	tiles.append_array(get_move_tiles_in_direction(tile, Vector2i.LEFT))
	tiles.append_array(get_move_tiles_in_direction(tile, Vector2i(1, 1)))
	tiles.append_array(get_move_tiles_in_direction(tile, Vector2i(1, -1)))
	tiles.append_array(get_move_tiles_in_direction(tile, Vector2i(-1, 1)))
	tiles.append_array(get_move_tiles_in_direction(tile, Vector2i(-1, -1)))
	return tiles


func get_attack_tiles_in_direction(tile: Vector2i, direction: Vector2i) -> Array[Vector2i]:
	var floorboard: Floorboard = Match.get_floorboard()
	var towerboard: Towerboard = Match.get_towerboard()
	var next_tile: Vector2i = tile + direction
	
	while not floorboard.is_tile_empty(next_tile):
		if not towerboard.is_tile_empty(next_tile):
			return [next_tile]
		next_tile = next_tile + direction
	
	return []


func get_move_tiles_in_direction(tile: Vector2i, direction: Vector2i) -> Array[Vector2i]:
	var floorboard: Floorboard = Match.get_floorboard()
	var towerboard: Towerboard = Match.get_towerboard()
	var tiles: Array[Vector2i] = []
	var next_tile: Vector2i = tile + direction
	
	while not floorboard.is_tile_empty(next_tile) and towerboard.is_tile_empty(next_tile):
		tiles.append(next_tile)
		next_tile = next_tile + direction
	
	return tiles
