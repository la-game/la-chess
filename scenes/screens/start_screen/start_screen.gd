extends MarginContainer


func _ready() -> void:
	Match.reset()
	Players.reset()
	
	# So you can use rpc calls before any player connect.
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()


func _on_host_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/host_screen/host_screen.tscn")


func _on_connect_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/connect_screen/connect_screen.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
