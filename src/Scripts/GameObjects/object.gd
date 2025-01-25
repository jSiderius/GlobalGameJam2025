extends StaticBody2D

class_name GameObject

var grid_pos:Vector2i
var sprite:Sprite2D

var area:Area2D
var collision_shape:CollisionShape2D

var draw_debug = true

func _init() -> void:
	area = Area2D.new()
	add_child(area)
	
	collision_shape = CollisionShape2D.new() 
	add_child(collision_shape)
	#collision_shape.position = scale * sprite.texture.get_size() / 2.0
	
	var shape = RectangleShape2D.new()
	collision_shape.shape = shape
	
	area.monitoring = true
	area.set_collision_layer_value(0, true)
	area.set_collision_mask_value(0, true)

func _draw() -> void:
	if not (collision_shape.shape and draw_debug): return
	var shape = collision_shape.shape
	#draw_rect(Rect2(-shape.extents, shape.extents * 2), Color(1, 0, 0, 0.5))

func set_size(button_size) -> void: 
	collision_shape.shape.extents = Vector2(button_size.x / 2, button_size.y / 2)
	collision_shape.position = Vector2(button_size.x / 2, button_size.y / 2)
	
