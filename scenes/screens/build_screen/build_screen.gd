extends Node


var selected_tower: int = 0

@export var map: Map

@export var towers_containter: HBoxContainer


func _ready() -> void:
	add_towers_button()


func add_towers_button() -> void:
	clear_towers_button()
	
	for id in map.towers:
		var towers_available: int = map.towers[id]
		
		if towers_available > 0:
			var button: Button = Button.new()
			
			button.text = str(towers_available)
			button.icon = Towers.get_tower_texture(id)
			button.add_theme_font_size_override("font_size", 64)
			button.pressed.connect(func(): selected_tower = id)
			
			towers_containter.add_child(button)


func clear_towers_button() -> void:
	for child in towers_containter.get_children():
		child.queue_free()
