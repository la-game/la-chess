extends Tower


func _init() -> void:
	NAME = "King"


func get_attack_tiles(tile: Vector2i) -> Array[Vector2i]:
	return [
		tile + Vector2i.UP,
		tile + Vector2i.UP + Vector2i.LEFT,
		tile + Vector2i.UP + Vector2i.RIGHT,
		tile + Vector2i.DOWN,
		tile + Vector2i.DOWN + Vector2i.LEFT,
		tile + Vector2i.DOWN + Vector2i.RIGHT,
		tile + Vector2i.RIGHT,
		tile + Vector2i.LEFT
	]


func get_move_tiles(tile: Vector2i) -> Array[Vector2i]:
	return [
		tile + Vector2i.UP,
		tile + Vector2i.UP + Vector2i.LEFT,
		tile + Vector2i.UP + Vector2i.RIGHT,
		tile + Vector2i.DOWN,
		tile + Vector2i.DOWN + Vector2i.LEFT,
		tile + Vector2i.DOWN + Vector2i.RIGHT,
		tile + Vector2i.RIGHT,
		tile + Vector2i.LEFT
	]
