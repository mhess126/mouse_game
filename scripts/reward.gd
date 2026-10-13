extends Node2D
class_name Reward

signal touched_player

@export var type: String = "unknown"
#@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		touched_player.emit()
		
		# todo:
		# play a sound
		AudioPlayer.play_sfx("pickup")
		# possibly add to player inventory
		set_deferred("disabled", true)
		#animation_player.play("pickup")
		queue_free()
