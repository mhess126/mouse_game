extends Control

func _ready() -> void:
	AudioPlayer.play_music()
	
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/intro_movie.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
