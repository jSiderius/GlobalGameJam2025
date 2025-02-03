extends TextureRect

@export var this_scene:PackedScene

@onready var object_cursor = get_node("/root/level_editor/editor_object")
@onready var cursor_sprite = object_cursor.get_node("Sprite")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 

func _item_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed: 
		object_cursor.current_item = this_scene
		cursor_sprite.texture = texture
		cursor_sprite.scale = Vector2(64.0 / texture.get_width(), 64.0 / texture.get_height())
