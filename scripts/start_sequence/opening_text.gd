extends Control

func _go_to_scene_1() -> void:
	get_tree().change_scene_to_file("res://scenes/start_sequence/opening_text_1.tscn")

func _go_to_scene_2() -> void:
	get_tree().change_scene_to_file("res://scenes/start_sequence/opening_text_2.tscn")

func _go_to_scene_3() -> void:
	get_tree().change_scene_to_file("res://scenes/start_sequence/opening_text_3.tscn")

func _go_to_bye_juliette_animation() -> void:
	get_tree().change_scene_to_file("res://scenes/start_sequence/bye_juliette.tscn")

func _go_to_game() -> void:
	# start game!
	pass
