extends GameObject

var velocity: Vector2 = Vector2.ZERO
var speed = 100.0

func _ready() -> void:
	pass
	
func _init() -> void:
	
	sprite = Sprite2D.new()
	sprite.texture = load("res://assets/Bubbles/Coloured/64x64/bubble_1.png")
	add_child(sprite)
	
	super._init()
	

func _draw() -> void:
	super._draw()
