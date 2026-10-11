extends Control

func _on_back_button_pressed() -> void:
	# go to pause menu
	get_tree().change_scene_to_file("res://scenes/menus/pause_menu.tscn")
