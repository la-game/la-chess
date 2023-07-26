extends Node2D


## Map loaded from BuildScreen
var map: Map

@export var board_camera: BoardCamera

@export var winner_container: Container

@export var winner_label: Label


func _ready() -> void:
	map = Match.map as Map
	board_camera.map = map
	
	# First add child to inherit the multiplayer property
	add_child(map)
	
	map.build_map.disable()
	map.battle_map.link_towers_to_click()
	Match.match_ended.connect(_on_match_ended)


@rpc("authority", "call_local", "reliable")
func show_winner(nickname: String) -> void:
	map.set_process_input(false)
	winner_label.text = "WINNER\n%s" % nickname
	winner_container.visible = true


func _on_match_ended(winner: int) -> void:
	print("MATCH ENDED")
	show_winner.rpc(Players.infos[winner]["nickname"])


func _on_back_button_pressed() -> void:
	Match.reset()
	Players.reset()
	get_tree().change_scene_to_file("res://scenes/screens/start_screen/start_screen.tscn")
