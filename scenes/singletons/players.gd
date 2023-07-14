extends Node


## Emitted when an information of a player change.
signal infos_changed


## Map a player id to that player information.
## Only the player owning that information should change it.
var infos: Dictionary

## Base dictionary for the player information.
const _info: Dictionary = {
	"nickname": "Player",
	"is_ready": false,
}


func _ready() -> void:
	reset()
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


## Reset the players informations, settings the default value back.
func reset() -> void:
	infos = {}


## Check if all players are ready.
func are_ready() -> bool:
	for info in infos.values():
		if not info["is_ready"]:
			return false
	return true


## Any player can update it own information for everybody.
@rpc("any_peer", "call_local", "reliable")
func update_info(new_info: Dictionary) -> void:
	var player_id: int = multiplayer.get_remote_sender_id()
	var info: Dictionary = infos.get(player_id, _info.duplicate())
	
	info.merge(new_info, true)
	infos[player_id] = info
	infos_changed.emit()


## When a new player connect, the server needs to send all public information to the new peer.
@rpc("authority", "call_remote", "reliable")
func update_infos(all_infos: Dictionary) -> void:
	infos.merge(all_infos)
	infos_changed.emit()


## When a player disconnect, everyone should remove it information.
func remove_info(player_id: int) -> void:
	infos.erase(player_id)
	infos_changed.emit()


func _on_peer_connected(id: int) -> void:
	# This validation needs to be here because when the node is created nobody knows who is the server.
	if multiplayer.is_server():
		update_infos.rpc_id(id, infos)


func _on_peer_disconnected(id: int) -> void:
	remove_info(id)
