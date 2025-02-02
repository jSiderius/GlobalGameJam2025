extends Node2D

var can_place = true 
@onready var level = get_node("../level")

var current_item:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

func _input(event):
	pass
	#if event is InputEventMouseButton and event.pressed:
		#if current_item != null and can_place: 
			#var new_item = current_item.instantiate()
			#level.add_child(new_item)
			#new_item.global_position = get_global_mouse_position()
