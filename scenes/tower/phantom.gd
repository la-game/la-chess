class_name Phantom
extends Sprite2D


signal released(tower: Tower, global_pos: Vector2)

var _tower: Tower


func _init(tower: Tower, on_released: Callable) -> void:
	_tower = tower
	texture = tower.texture
	modulate.a = 0.4
	
	released.connect(on_released)
	tower.add_child(self)


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	visible = _tower.global_position.distance_to(global_position) > 50


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_released("left_click"):
			released.emit(_tower, global_position)
			queue_free()
