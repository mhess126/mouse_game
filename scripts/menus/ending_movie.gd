extends Node

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const CREDITS = preload("uid://hmj71sphpyo7")
	
func _on_animated_sprite_2d_animation_finished() -> void:
		# Wait for 2.0 seconds
	await get_tree().create_timer(3.0).timeout	
	get_tree().change_scene_to_packed(CREDITS)
