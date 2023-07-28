extends Node


var colors: Array[Color] = [
	Color(255, 255, 255),
	Color(0, 0, 0),
	Color(255, 0, 0),
	Color(0, 0, 255),
	Color(0, 255, 0),
	Color(255, 255, 0),
	Color(0, 255, 255),
	Color(255, 0, 255),
]


func get_player_color(player_id: int) -> Color:
	return colors[Match.order.find(player_id)]
