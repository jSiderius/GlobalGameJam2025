extends Node2D

var game_grid = []
@onready var grid_anchor:Control = $GridAnchor
@onready var grid:GridContainer = $GridAnchor/GridContainer
@onready var editor_object:Node2D = $editor_object
const grid_button_theme = preload("res://assets/Themes/grid_button.tres")

func _ready() -> void:
	set_grid(5)
	
func set_grid(grid_size:int): 
	empty_grid()
	grid.columns = grid_size
	populate_grid(grid_size)

func empty_grid(): 
	for i in range(len(game_grid)): 
		for j in range(len(game_grid[i])): 
			game_grid[i][j].queue_free()
	game_grid = []
	
func populate_grid(grid_size:int) -> void: 
	game_grid = []
	for i in range(grid_size): 
		game_grid.append([])
		for j in range(grid_size):
			game_grid[i].append(create_cell(Vector2i(i, j)))

func create_cell(pos:Vector2i) -> Button: 
	var button = Button.new() 
	button.text = ""
	button.custom_minimum_size = Vector2(64, 64)
	
	button.pressed.connect(_on_button_pressed.bind(button, pos))
	button.theme = grid_button_theme
	grid.add_child(button)
	return button

func _on_button_pressed(button:Button, pos:Vector2i):
	if editor_object.current_item != null and editor_object.can_place: 
		var new_item = editor_object.current_item.instantiate()
		button.add_child(new_item)
		
		
		#var button_size = button.get_custom_minimum_size()
		#var texture_size = new_item.get_node("AnimatedSprite2D").texture.get_size()
		#
		#var scale_factor = 0.8 * min(button_size.x / texture_size.x, button_size.y / texture_size.y)
		#new_item.get_node("AnimatedSprite2D").scale = Vector2(scale_factor, scale_factor)
		#new_item.get_node("AnimatedSprite2D").position = button_size / 2.0
		#grid_anchor.add_child(new_item)
		#new_item.global_position = button.global_position
