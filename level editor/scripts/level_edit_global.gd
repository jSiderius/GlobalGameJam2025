extends Node

var MAX_GRID_SIZE = 11
var grid_size:int = 0
@onready var level_editor = get_node("/root/level_editor")

func update_grid_size(new_size:int): 
	if new_size <0 or new_size > 11:
		print_debug("Invalid grid size") 
		return
		
	grid_size = new_size
	level_editor.set_grid(grid_size)
	
	
