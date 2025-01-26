extends Node

var num_levels = 10
var active_level = 0
var level_completed_bools = []
var level_paths = []

func _ready() -> void:
	for i in range(num_levels): 
		level_completed_bools.append(false)
		level_paths.append("res://src/scenes/levels/" + str(i+1) + ".tscn")
		
	
