extends Button

signal rotate_grid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite = $Sprite
	custom_minimum_size = sprite.texture.get_size()
	sprite.position += Vector2(custom_minimum_size.x / 2, custom_minimum_size.y / 2)
	pressed.connect(rot)

func rot():
	emit_signal("rotate_grid")
