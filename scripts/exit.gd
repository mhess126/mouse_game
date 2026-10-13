extends Area2D

const ENDING_MOVIE = preload("uid://nb6tyyxrefjb")

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		get_tree().change_scene_to_packed(ENDING_MOVIE)
