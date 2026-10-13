extends Control

const START_MENU = preload("uid://figakeric4xe")

func ready() -> void:
	await get_tree().create_timer(20.0).timeout	
	get_tree().change_scene_to_packed(START_MENU)
	
