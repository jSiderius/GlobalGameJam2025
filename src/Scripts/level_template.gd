extends Node2D

@export var level_number: int = 99

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.active_level = level_number
	
	$HBoxContainer/RightButton.connect("rotate_grid", rotate_grid.bind("right"))
	$HBoxContainer/LeftButton.connect("rotate_grid", rotate_grid.bind("left"))
	$HBoxContainer/CenterButton.connect("rotate_grid", rotate_grid.bind("center"))

func rotate_grid(dir:String): 
	$GridScene.rotate_grid(dir)
