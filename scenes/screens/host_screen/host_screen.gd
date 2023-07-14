extends MarginContainer


@export var nickname: LineEdit

@export var port: LineEdit

@export var warning: Label


func _ready() -> void:
	get_tree().root.multiplayer.multiplayer_peer.close()


func update_warning(text: String) -> void:
	warning.text = text


func _on_start_hosting_pressed() -> void:
	if not port.text.is_valid_int():
		return update_warning("Port must be a valid integer")
	
	var peer: MultiplayerPeer = ENetMultiplayerPeer.new()
	var error = peer.create_server(int(port.text))
	
	match error:
		ERR_CANT_CREATE:
			return update_warning("Unknown error while creating connection")
		ERR_ALREADY_IN_USE:
			return update_warning("Connection is already in use")
	
	Players.update_info.rpc({"nickname": nickname.text})
	
	get_tree().root.multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://scenes/screens/lobby_screen/lobby_screen.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/start_screen/start_screen.tscn")
