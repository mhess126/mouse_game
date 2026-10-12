extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# start music slow?
	pass # Replace with function body.

func _start_game():
	get_tree().change_scene_to_file("res://scenes/levels/smart_shape_level.tscn")
