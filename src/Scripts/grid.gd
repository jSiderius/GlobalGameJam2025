extends Control

@onready var grid_anchor:Control = $GridAnchor
@onready var grid:GridContainer = $GridAnchor/GridContainer

const init_bubble = preload("res://src/Scripts/GameObjects/bubble.gd")
const init_block = preload("res://src/Scripts/GameObjects/block.gd")
const GRID_SIZE = 7

var game_grid = [] 
var bubbles = []
var blocks = []
var selected_button:Vector2i
var in_motion:bool = false

@export var INIT_BUBBLE_POSITIONS:Array[Vector2i]
@export var INIT_BLOCK_POSITIONS:Array[Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid.columns = GRID_SIZE
	populate_grid()
	center_grid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func populate_grid() -> void: 
	game_grid = []
	for i in range(GRID_SIZE): 
		game_grid.append([])
		for j in range(GRID_SIZE):
			game_grid[i].append(create_cell(Vector2i(i, j)))
	
	call_deferred("populate_objects", init_bubble, INIT_BUBBLE_POSITIONS, bubbles)
	call_deferred("populate_objects", init_block, INIT_BLOCK_POSITIONS, blocks)

# Todo: probably need a storage array 
func populate_objects(initializer, position_array, append_array) -> void: 
	for pos in position_array: 
		if pos.x >= GRID_SIZE or pos.y >= GRID_SIZE or pos.x < 0 or pos.y <0: 
			print_debug("An objects position is out of range")
			get_tree().quit()
		
		var button = game_grid[pos.x][pos.y]
		var object = initializer.new()
		
		var button_size = button.get_custom_minimum_size()
		var texture_size = object.sprite.texture.get_size()
		object.set_size(button_size)
		
		var scale_factor = 0.8 * min(button_size.x / texture_size.x, button_size.y / texture_size.y)
		object.sprite.scale = Vector2(scale_factor, scale_factor)
		object.sprite.position = button_size / 2.0
		grid_anchor.add_child(object)
		object.global_position = button.global_position
		object.grid_pos = pos
		append_array.append(object)

func center_grid() -> void: 
	var viewport_size = get_viewport_rect().size
	grid_anchor.position = Vector2(0, 0)
	grid_anchor.position = Vector2(
		viewport_size.x / 2.0,
		viewport_size.y / 2.0 )
	
	grid.position = Vector2(0, 0)
	grid.position = Vector2(
		- grid.get_rect().size.x / 2.0, 
		- grid.get_rect().size.y / 2.0  )
	
func _on_button_pressed(pos:Vector2i): 
	selected_button = pos
	print("Button Pressed: ", pos)

func create_cell(pos:Vector2i) -> Button: 
	var button = Button.new() 
	button.text = "1"
	button.custom_minimum_size = Vector2(64, 64)
	
	button.pressed.connect(_on_button_pressed.bind(pos))
	grid.add_child(button)
	return button
	
func _physics_process(delta: float) -> void:
	#grid_anchor.rotation += PI * delta / 2
	pass

func rotate_grid(left:bool): 
	if in_motion: return
	var target_rotation = grid_anchor.rotation
	if left: 
		target_rotation -= PI / 2
	else: 
		target_rotation += PI / 2
		
	var tween = create_tween()
	in_motion = true
	tween.tween_property(grid_anchor, "rotation", target_rotation, 0.5)
	tween.connect("finished", grid_rotation_finished)

func grid_rotation_finished(): 
	
	for b in bubbles: 
		var tween = create_tween()
		var new_pos = find_bubble_new_pos(b.grid_pos)
		#print(new_pos)
		if new_pos == Vector2i(-1, -1): continue
		if new_pos == Vector2i(-2, -2): 
			tween.tween_property(b, "position", Vector2(-100, game_grid[new_pos.x][new_pos.y].global_position.y), 1.0)
			tween.connect("finished", bubble_traversal_finished)
			continue
		var target_pos = game_grid[new_pos.x][new_pos.y].global_position
		tween.tween_property(b, "global_position", target_pos, 1.0)
		tween.connect("finished", bubble_traversal_finished)

func bubble_traversal_finished(): 
	in_motion = false

func find_bubble_new_pos(bubble_pos:Vector2i) -> Vector2i:
	var closest_block = null
	for block in blocks: 
		#print(bubble_pos, " ", block.grid_pos)
		if block.grid_pos.y == bubble_pos.y and (closest_block == null or closest_block > block.grid_pos.x): 
			closest_block = block.grid_pos.x
	#print(closest_block)
	if closest_block == null: return Vector2i(-1, -1)
	if closest_block >= bubble_pos.x: return Vector2i(-2, -2)
	return Vector2i(closest_block+1, bubble_pos.y)
	
	
