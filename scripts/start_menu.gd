extends Control

func _ready() -> void:
	AudioPlayer.play_music()
	
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/mouse_level.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
