extends Control

func _ready() -> void:
	AudioPlayer.play_music()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/start_sequence/opening_text_1.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
