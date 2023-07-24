class_name BoardCamera
extends Camera2D


var tween: Tween

@export var map: Map


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				move(get_global_mouse_position())
			MOUSE_BUTTON_WHEEL_DOWN:
				change_zoom(-0.1)
			MOUSE_BUTTON_WHEEL_UP:
				change_zoom(0.1)


func move(global_pos: Vector2) -> void:
	if tween:
		tween.kill()
	
	var floorboard: Floorboard = map.battle_map.floorboard
	var local_pos: Vector2 = floorboard.to_local(global_pos)
	
	if floorboard.is_pos_empty(local_pos):
		return
	
	tween = create_tween().bind_node(self)
	tween.tween_property(self, "global_position", global_pos, 0.2)


func change_zoom(value: float) -> void:
	var t = clampf(zoom.x + value, 0.1, 1.0)
	zoom = Vector2(t, t)
