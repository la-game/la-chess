extends Node2D


## Map loaded from BuildScreen
var map: Map

@export var winner_label: Label


func _ready() -> void:
	map = Match.map as Map
	
	# First add child to inherit the multiplayer property
	add_child(map)
	
	map.build_map.disable()
	map.battle_map.link_towers_to_click()
	Match.match_ended.connect(_on_match_ended)


@rpc("authority", "call_local", "reliable")
func show_winner(nickname: String) -> void:
	map.set_process_input(false)
	winner_label.text = "WINNER\n%s" % nickname
	winner_label.visible = true


func _on_match_ended(winner: int) -> void:
	print("MATCH ENDED")
	show_winner.rpc(Players.infos[winner]["nickname"])
	



