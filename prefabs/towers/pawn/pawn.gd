extends Tower


func _init() -> void:
	NAME = "Pawn"


func get_attack_tiles(tile: Vector2i) -> Array[Vector2i]:
	if front.x == 0:
		return [
			tile + front + Vector2i.RIGHT,
			tile + front + Vector2i.LEFT
		]
	elif front.y == 0:
		return [
			tile + front + Vector2i.UP,
			tile + front + Vector2i.DOWN
		]
	return [
		tile + front - Vector2i(front.x, 0),
		tile + front - Vector2i(0, front.y)
	]


func get_move_tiles(tile: Vector2i) -> Array[Vector2i]:
	return [tile + front]
