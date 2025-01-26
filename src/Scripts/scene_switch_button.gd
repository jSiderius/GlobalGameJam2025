extends Button

@export var scene_switch:String = ""

func _on_pressed() -> void:
	if scene_switch == "": return
	if scene_switch == "active_level": 
		get_tree().change_scene_to_file(Global.level_paths[Global.active_level])
		return 
	elif scene_switch == "next_level" and Global.active_level + 1 < Global.num_levels:
		get_tree().change_scene_to_file(Global.level_paths[Global.active_level+1])
		return  
		
	get_tree().change_scene_to_file(scene_switch)
