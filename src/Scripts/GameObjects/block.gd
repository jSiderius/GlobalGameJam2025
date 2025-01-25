extends GameObject


func _ready() -> void:
	pass

func _init() -> void:
	
	sprite = Sprite2D.new()
	sprite.texture = load("res://assets/stone.png")
	#sprite.position = Vector2(200,100)
	add_child(sprite)
	
	super._init()
	

func _draw() -> void:
	super._draw()
