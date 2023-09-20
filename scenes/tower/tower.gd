class_name Tower
extends Sprite2D


signal left_clicked(tower: Tower)

var IDENTIFIER: int = -1

var NAME: String = "Undefined"

var front: Vector2i

var player_id: int

var steps: int = 0

@export var _area: Area2D

@export var _border: Sprite2D


func _ready() -> void:
	_area.input_event.connect(_area_input_event)


func set_border_color(color: Color) -> void:
	_border.modulate = color
	self_modulate = color


func get_attack_tiles(_tile: Vector2i) -> Array[Vector2i]:
	return []


func get_move_tiles(_tile: Vector2i) -> Array[Vector2i]:
	return []


func _area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			left_clicked.emit(self)
