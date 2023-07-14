class_name LobbyPlayers
extends GridContainer


signal players_changed


func _ready() -> void:
	refresh()
	
	Match.order_changed.connect(refresh)
	Players.infos_changed.connect(refresh)


func refresh() -> void:
	clear()
	
	for id in Match.order:
		if id in Players.infos:
			add_player(id)
	
	players_changed.emit()


func clear() -> void:
	for child in get_children():
		child.queue_free()


func add_player(id: int) -> void:
	var info: Dictionary = Players.infos[id]
	var nickname_label: Label = Label.new()
	var ready_label: Label = Label.new()
	var up_button: Button = Button.new()
	var down_button: Button = Button.new()
	
	if not multiplayer.is_server():
		up_button.disabled = true
		down_button.disabled = true
	
	nickname_label.text = info["nickname"]
	ready_label.text = "✔️" if info["is_ready"] else ""
	up_button.text = "up"
	down_button.text = "down"
	
	up_button.pressed.connect(move_up.bind(id))
	down_button.pressed.connect(move_down.bind(id))
	
	add_child(nickname_label)
	add_child(ready_label)
	add_child(up_button)
	add_child(down_button)


func move_up(id: int) -> void:
	var index = Match.order.find(id)
	
	if index in [-1, 0]:
		return
	
	var temp = Match.order[index - 1]
	Match.order[index - 1] = Match.order[index]
	Match.order[index] = temp
	Match.set_order.rpc(Match.order)


func move_down(id: int) -> void:
	var index = Match.order.find(id)
	var last = Match.order.size() - 1
	
	if index in [-1, last]:
		return
	
	var temp = Match.order[index + 1]
	Match.order[index + 1] = Match.order[index]
	Match.order[index] = temp
	Match.set_order.rpc(Match.order)
