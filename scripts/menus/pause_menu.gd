extends Control

func _ready() -> void:
	# swap to play the "start/pause" track instead of the gameplay music
	AudioPlayer.play_music()

func _on_resume_button_pressed() -> void:
	# resume game (how do i do this?)
	pass

func _on_quit_button_pressed():
	get_tree().quit()

func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/controls_menu.tscn")
