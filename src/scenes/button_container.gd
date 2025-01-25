extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	global_position = Vector2(
		viewport_size.x / 2.0 - get_rect().size.x / 2.0,
		viewport_size.y - 1.1 * get_rect().size.y
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
