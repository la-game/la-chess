class_name Towerboard
extends Board


var towers: Dictionary = {}


## Get a tower in a specific location.
func get_tower(local_pos: Vector2) -> Tower:
	return towers.get(local_to_map(local_pos))


## Get all towers in the board.
## It's sugar syntax for when you want an Array[Towers].
func get_towers() -> Array[Tower]:
	var all_towers: Array[Tower] = []
	all_towers.assign(towers.values())
	return all_towers


func get_tower_tile(tower: Tower):
	for tile in towers:
		if towers[tile] == tower:
			return tile as Vector2i
	return null


## Returns true if the tower has being created, false otherwise.
func create_tower(tower: Tower, local_pos: Vector2) -> bool:
	return create_tower_on_tile(tower, local_to_map(local_pos))


## Returns true if the tower has being created, false otherwise.
## Failing to create means that there is already a tower in that tile.
func create_tower_on_tile(tower: Tower, tile: Vector2i) -> bool:
	if towers.get(tile):
		return false
	
	towers[tile] = tower
	tower.position = map_to_local(tile)
	
	add_child(tower)
	
	return true


## Returns true if the tower attacked other tower, false otherwise.
@rpc("authority", "call_remote", "reliable")
func attack_tower(tower: Tower, local_pos: Vector2) -> bool:
	var tile = get_tower_tile(tower)
	var tile_destine = local_to_map(local_pos)
	
	if tile_destine in tower.get_attack_tiles(tile):
		if erase_tower_on_tile(tile_destine):
			return move_tower_on_tile(tile, tile_destine)
	return false


## Returns true if the tower moved, false otherwise.
func move_tower(tower: Tower, local_pos: Vector2) -> bool:
	var tile = get_tower_tile(tower)
	var tile_destine = local_to_map(local_pos)
	
	if tile_destine in tower.get_move_tiles(tile):
		return move_tower_on_tile(tile, tile_destine)
	return false


## Returns true if the tower moved, false otherwise.
func move_tower_on_tile(tile_origin: Vector2i, tile_destine: Vector2i) -> bool:
	if towers.get(tile_origin) == null or towers.get(tile_destine) != null:
		return false
	
	towers[tile_destine] = towers[tile_origin]
	towers[tile_destine].position = map_to_local(tile_destine)
	towers.erase(tile_origin)
	
	return true


## Returns true if the tower has been erased, false otherwise.
func erase_tower(tower: Tower) -> bool:
	var tile = get_tower_tile(tower)
	
	if tile:
		return erase_tower_on_tile(tile)
	return false


## Returns true if the tower has been erased, false otherwise.
func erase_tower_on_tile(tile: Vector2i) -> bool:
	var tower: Tower = towers.get(tile)
	
	if tower:
		towers.erase(tile)
		tower.queue_free()
		return true
	
	return false


## Overwrite [Board.is_tile_empty].
func is_tile_empty(tile: Vector2i, _layer: int = 0) -> bool:
	return towers.get(tile) == null


## Tower can't be passed through RPC, this only exist so the server can call this action in others.
@rpc("authority", "call_remote", "reliable")
func request_move_tower(tower_tile: Vector2i, local_pos: Vector2) -> void:
	var tower: Tower = towers[tower_tile]
	move_tower(tower, local_pos)


## Tower can't be passed through RPC, this only exist so the server can call this action in others.
@rpc("authority", "call_remote", "reliable")
func request_attack_tower(tower_tile: Vector2i, local_pos: Vector2) -> void:
	var tower: Tower = towers[tower_tile]
	attack_tower(tower, local_pos)
