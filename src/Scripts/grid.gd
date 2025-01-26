extends Control

@onready var grid_anchor:Control = $GridAnchor
@onready var grid:GridContainer = $GridAnchor/GridContainer
@onready var move_counter = $MoveCounter
@onready var bubble_counter = $BubbleCounter

const init_bubble = preload("res://src/Scripts/GameObjects/bubble.gd")
const init_block = preload("res://src/Scripts/GameObjects/block.gd")
const init_spike = preload("res://src/Scripts/GameObjects/spike.gd")
const grid_button_theme = preload("res://assets/Themes/grid_button.tres")

var game_grid = [] 
var bubbles = []
var blocks = []
var spikes = []
var selected_button:Vector2i
var in_motion:bool = false

@export var INIT_BUBBLE_POSITIONS:Array[Vector2i]
@export var INIT_BLOCK_POSITIONS:Array[Vector2i]
@export var INIT_SPIKE_POSITIONS:Array[Vector2i]
@export var num_moves:int = 0
@export var GRID_SIZE:int = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid.columns = GRID_SIZE
	populate_grid()
	center_grid()
	call_deferred("update_counters")

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
	call_deferred("populate_objects", init_spike, INIT_SPIKE_POSITIONS, spikes)

func populate_objects(initializer, position_array, append_array) -> void: 
	for pos in position_array: 
		if pos.x >= GRID_SIZE or pos.y >= GRID_SIZE or pos.x < 0 or pos.y <0: 
			print_debug("An objects position is out of range")
			get_tree().quit()
		
		var button = game_grid[pos.x][pos.y]
		var object = initializer.new()
		
		var button_size = button.get_custom_minimum_size()
		var texture_size = object.sprite.texture.get_size()
		
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

func create_cell(pos:Vector2i) -> Button: 
	var button = Button.new() 
	button.text = ""
	button.custom_minimum_size = Vector2(64, 64)
	
	button.pressed.connect(_on_button_pressed.bind(pos))
	button.theme = grid_button_theme
	grid.add_child(button)
	return button

func rotate_grid(dir:String): 
	if in_motion: return
	var target_rotation = grid_anchor.rotation
	if dir == "left": 
		target_rotation -= PI / 2
		rotate_grid_array(true)
	elif dir == "right": 
		target_rotation += PI / 2
		rotate_grid_array(false)
	else:
		target_rotation += PI 
		rotate_grid_array(true)
		rotate_grid_array(true)
			
	var tween = create_tween()
	in_motion = true
	tween.tween_property(grid_anchor, "rotation", target_rotation, 0.5)
	tween.connect("finished", grid_rotation_finished)
	
func rotate_grid_array(left:bool): 
	var new_array = Array()
	for i in range(GRID_SIZE): 
		var sub_array:Array[Button] = []
		sub_array.resize(GRID_SIZE)
		new_array.append(sub_array)
	for i in range(GRID_SIZE): for j in range(GRID_SIZE): 
		if left: 
			new_array[i][j] = game_grid[j][GRID_SIZE - i - 1]
		else: 
			new_array[i][j] = game_grid[GRID_SIZE - j - 1][i]
	game_grid = new_array
	
#	TODO: This can be a function easily, total waste of space 
	for bubble in bubbles: 
		if left: 
			bubble.grid_pos = Vector2i(GRID_SIZE - bubble.grid_pos.y - 1, bubble.grid_pos.x)
		else: 
			bubble.grid_pos = Vector2i(bubble.grid_pos.y, GRID_SIZE - bubble.grid_pos.x - 1)
	for block in blocks: 
		if left: 
			block.grid_pos = Vector2i(GRID_SIZE - block.grid_pos.y - 1, block.grid_pos.x)
		else: 
			block.grid_pos = Vector2i(block.grid_pos.y, GRID_SIZE - block.grid_pos.x - 1)
	for spike in spikes: 
		if left: 
			spike.grid_pos = Vector2i(GRID_SIZE - spike.grid_pos.y - 1, spike.grid_pos.x)
		else: 
			spike.grid_pos = Vector2i(spike.grid_pos.y, GRID_SIZE - spike.grid_pos.x - 1)
	
func grid_rotation_finished(): 
	if len(bubbles) == 0: end_turn()
	
	var tweens = []
	bubbles.sort_custom(_sort_by_x_grid_pos)
	for b in bubbles: 
		var tween = create_tween()
		tweens.append(tween)
		var new_pos = find_bubble_new_pos(b.grid_pos)
		if new_pos == Vector2i(-1, -1): 
			tween.tween_property(b, "global_position", Vector2(b.global_position.x, -100), 1.0)
			tween.connect("finished", delete_bubble.bind(b))
			b.grid_pos = Vector2(1000, b.grid_pos.y)
			continue
		var target_pos = game_grid[new_pos.x][new_pos.y].global_position
		b.grid_pos = new_pos
		tween.tween_property(b, "global_position", target_pos, 1.0)
	if len(tweens) > 0: 
		tweens[-1].connect("finished", end_turn)

func _sort_by_x_grid_pos(a, b): 
	return a.grid_pos.x < b.grid_pos.x

func delete_bubble(bubble): 
	bubbles.erase(bubble)
	bubble.queue_free()
	
func end_turn(): 
	in_motion = false
	num_moves -= 1
	if len(bubbles) <= 0 and not bubble_pops:
		Global.level_completed_bools[Global.active_level] = true #TODO: A bit flawed, assumes no interference since level initiated 
		Global.active_level = min(Global.active_level+1, Global.num_levels-1)
		get_tree().change_scene_to_file("res://src/scenes/win_ui.tscn")
	elif num_moves <= 0 or bubble_pops:
		get_tree().change_scene_to_file("res://src/scenes/loss_ui.tscn")
	update_counters()
	
var bubble_pops = false
func find_bubble_new_pos(bubble_pos:Vector2i) -> Vector2i:
	var closest_block = null
	for block in blocks: 
		if block.grid_pos.y == bubble_pos.y and ((closest_block == null or closest_block < block.grid_pos.x) and block.grid_pos.x < bubble_pos.x): 
			closest_block = block.grid_pos.x
	for bubble in bubbles: 
		if bubble.grid_pos == bubble_pos: continue
		if bubble.grid_pos.y == bubble_pos.y and ((closest_block == null or closest_block < bubble.grid_pos.x) and bubble.grid_pos.x < bubble_pos.x): 
			closest_block = bubble.grid_pos.x
	for spike in spikes: 
		if spike.grid_pos.y == bubble_pos.y and spike.grid_pos.x < bubble_pos.x and (closest_block == null or closest_block < spike.grid_pos.x): 
			bubble_pops = true
			return Vector2i(spike.grid_pos.x, bubble_pos.y)
	if closest_block == null or closest_block >= bubble_pos.x: return Vector2i(-1, -1)
	return Vector2i(closest_block+1, bubble_pos.y)
	
func update_counters() -> void: 
	move_counter.text = str(num_moves)
	bubble_counter.text = str(len(bubbles))
	
