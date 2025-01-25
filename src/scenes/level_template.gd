extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/RightButton.connect("rotate_grid", rotate_grid.bind(false))
	$HBoxContainer/LeftButton.connect("rotate_grid", rotate_grid.bind(true))


func rotate_grid(left:bool): 
	$GridScene.rotate_grid(left)
