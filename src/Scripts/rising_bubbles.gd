extends Node2D

@export var sprite_path = "res://assets/Bubbles/Coloured/64x64/bubble_4.png"
@export var num_sprites = 20 
@export var rise_speed_range = Vector2(70, 110)
@export var spawn_area_range_x = Vector2(0, 900)
@export var spawn_area_range_y = Vector2(900, 1200)

var sprite_instances = []
var sprite_speeds = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(num_sprites): 
		spawn_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var viewport_rect = get_viewport_rect()
	for i in range(len(sprite_instances)):
		sprite_instances[i].position.y -= sprite_speeds[i]*delta
		if sprite_instances[i].position.y < -15: 
			respawn_sprite(i)
	
func spawn_sprite(): 
	var sprite = Sprite2D.new()
	sprite.texture = load(sprite_path)
	sprite.position = Vector2(randi() % int(spawn_area_range_x.y) + int(spawn_area_range_x.x),randi() % int(spawn_area_range_y.y) + int(spawn_area_range_y.x))
	sprite.z_index = -5
	add_child(sprite)
	sprite_instances.append(sprite)
	sprite_speeds.append(randf_range(rise_speed_range.x, rise_speed_range.y))

func respawn_sprite(index): 
	sprite_instances[index].position = Vector2(randi() % int(spawn_area_range_x.y) + int(spawn_area_range_x.x),randi() % int(spawn_area_range_y.y) + int(spawn_area_range_y.x))
	sprite_speeds[index] = randf_range(rise_speed_range.x, rise_speed_range.y)
	
	
	
