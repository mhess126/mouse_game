extends Node2D
class_name Reward

signal touched_player

@export var type: String = "unknown"
#@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_2d_body_entered(body):
	if body is Player:
		touched_player.emit()
		
		# todo:
		# play a sound
		# possibly add to player inventory
		set_deferred("disabled", true)
		#animation_player.play("pickup")
		queue_free()
