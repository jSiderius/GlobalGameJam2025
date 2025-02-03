extends Node

signal set_new_level(Level)

var level:Level = Level.new()
var num_levels = 10
var active_level = 0
var level_completed_bools = []
var level_paths = []

func _ready() -> void:
	for i in range(num_levels): 
		level_completed_bools.append(false)
		level_paths.append("res://src/scenes/levels/" + str(i+1) + ".tscn")
		
	var dir = DirAccess.open("user://levels")
	if not dir:
		DirAccess.make_dir_recursive_absolute("user://levels")

func open_level(lvl_num:int) -> void: 
	if lvl_num > num_levels: #and level is playable 
		return 
	
	level = ResourceLoader.load("user://levels/" + str(lvl_num+1) + ".tres")	
	get_tree().change_scene_to_file("res://src/scenes/level_template.tscn")

func save_level() -> void: 
	level.bubble_positions = [Vector2i(2,1)]
	level.block_positions = [Vector2i(2, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(3, 1), Vector2i(3, 2), Vector2i(2, 3)]
	level.grid_size = 4
	level.num_moves = 3
	ResourceSaver.save(level, "user://levels/1.tres")
