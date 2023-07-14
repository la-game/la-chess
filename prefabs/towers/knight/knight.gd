extends Tower


func _init() -> void:
	NAME = "Knight"


func get_attack_tiles(tile: Vector2i) -> Array[Vector2i]:
	return [
		tile + Vector2i(-2, 1),
		tile + Vector2i(2, 1),
		tile + Vector2i(-2, -1),
		tile + Vector2i(-2, -1)
	]


func get_move_tiles(tile: Vector2i) -> Array[Vector2i]:
	return [
		tile + Vector2i(-2, 1),
		tile + Vector2i(2, 1),
		tile + Vector2i(-2, -1),
		tile + Vector2i(-2, -1)
	]
