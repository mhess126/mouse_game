extends Area2D

@export_range(0.0, 2000.0, 1.0) var jump_force: float = 300

@onready var animated_sprite = $AnimatedSprite2D

func _on_body_entered(body):
	if body is Player:
		animated_sprite.play("jump")
		body.jump(jump_force)
