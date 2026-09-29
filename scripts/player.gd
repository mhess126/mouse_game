extends CharacterBody2D
class_name Player

@export var gravity = 400
@export var jump_force = 140
@export var speed = 400
@export var max_jumps = 2
@export var rotation_speed = 20.0

@export var acceleration = 1200.0  # How fast you speed up
@export var friction = 400.0      # How fast you slide to a stop
@onready var components: Node2D = $Components
@onready var animated_sprite = $Components/AnimatedSprite2D
@onready var wing_sprite: Sprite2D = $Components/WingSprite

var active = true
var jumps = 0

func _physics_process(delta):
	if is_on_floor()==false:
		jumps = 0
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
	else:
		# Get angle of floor
		var normal = get_floor_normal()
		# Calculate target rotation from the normal
		var target_rotation = normal.angle() + PI / 2
		if components.scale.x < 0:
			target_rotation = -target_rotation
			
		# Smoothly rotate toward the slope angle
		animated_sprite.rotation = lerp_angle(animated_sprite.rotation, target_rotation, rotation_speed * delta)
	var direction = 0
	if active==true:
		if Input.is_action_just_pressed("jump") && jumps < max_jumps && is_on_floor():
			jump(jump_force)
			jumps += 1
		direction = Input.get_axis("move_left", "move_right")
	
	# horizontal movement
	if direction != 0:
		# Use abs() to keep the original scale size, then multiply by the direction sign (-1 or 1)
		components.scale.x = abs(components.scale.x) * sign(direction)
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()
	
	update_animations(direction)

func jump(force):
	AudioPlayer.play_sfx("jump")
	velocity.y = -force

func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")

func reward(reward: String):
	if reward == "wing":
		wing_sprite.visible = true
		max_jumps = 4
	
