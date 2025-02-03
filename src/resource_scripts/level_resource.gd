class_name Level
extends  Resource

const SAVE_PATH := "user://save.tres"

@export var bubble_positions:Array[Vector2i] = []
@export var block_positions:Array[Vector2i] = []
@export var spike_positions:Array[Vector2i] = []
@export var num_moves:int = 0
@export var grid_size:int = 7

func write_level_save() -> void:
	ResourceSaver.save(self, SAVE_PATH) 

func load_level() -> Resource: 
	#if not ResourceLoader.has_cached(SAVE_PATH)
	return ResourceLoader.load(SAVE_PATH, "")
