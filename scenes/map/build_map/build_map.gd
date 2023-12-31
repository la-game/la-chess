## Responsible for the logic of build towers.
class_name BuildMap
extends Node2D


## Emitted when the map detects a left click.
signal left_clicked(global_pos: Vector2)

enum {
	TOWER_BUILT,
	TOWER_DESTROIED,
	NO_ACTION,
}

## Floorboard responsible to know where the towers can exist.
@export var floorboard: Floorboard

## This represents only yours towers, not the eneyme towers.
@export var towerboard: Towerboard

## Array of buildboards for this map. One for each player.
@export var buildboards: Array[Buildboard]

## Area to detect map clicks.
@export var area: Area2D


func _ready() -> void:
	area.input_event.connect(_on_area_input_event)


## Get the buildboard which a player can interact.
func get_buildboard(player_id: int) -> Buildboard:
	var index: int = Match.order.find(player_id)
	return buildboards[index]


## Try to build a tower in a specific buildboard.
## [br]Returns true if successfuly build the tower, false otherwise.
func build_tower(tower: Tower, local_pos: Vector2, player_id: int) -> bool:
	var buildboard: Buildboard = get_buildboard(player_id)
	
	# Don't build if there is no floor.
	if floorboard.is_pos_empty(local_pos):
		return false
	
	# If you fail to block the tile, is not a free tile.
	if not buildboard.block(local_pos):
		return false
	
	tower.front = buildboard.front
	tower.player_id = player_id
	tower.set_border_color(Colors.get_player_color(player_id))
	
	return towerboard.create_tower(tower, local_pos)


## Try to destroy a tower in a specific buildboard.
## [br]Returns true if successfuly destroy the tower, false otherwise.
func destroy_tower(local_pos: Vector2, player_id: int) -> bool:
	var buildboard: Buildboard = get_buildboard(player_id)
	
	# Don't destroy if there is no floor.
	if floorboard.is_pos_empty(local_pos):
		return false
	
	var tower: Tower = towerboard.get_tower(local_pos)
	
	# There is no tower to erase in this position.
	if tower == null:
		return false
	
	# If you fail to unblock the tile, is not a blocked tile.
	if not buildboard.unblock(local_pos):
		return false
	
	return towerboard.erase_tower(tower)


## Disable so the player can't build more towers.
@rpc("authority", "call_local", "reliable")
func disable() -> void:
	for buildboard in buildboards:
		buildboard.hide()
	area.hide()


func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			left_clicked.emit(get_global_mouse_position())
