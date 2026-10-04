extends CharacterBody2D
class_name Player

@export var max_stamina: float = 100.0
@export var stamina_recharge_rate: float = 30.0
@export var stamina_recharge_delay: float = 0.2
@export var pedal_stamina_cost: float = 7.0
@export var gravity = 400
@export var jump_force = 140
@export var speed = 400
@export var max_jumps = 2
@export var rotation_speed = 5.0
@export var pedal_buffer_timer: float = 0.0
@export var pedal_buffer_duration: float = 0.3 # 100 milliseconds buffer window

@export var acceleration = 1200.0  # How fast you speed up
@export var friction = 400.0      # How fast you slide to a stop
@export var slope_gravity_scale = 1.0  # How strongly slopes pull you downhill
@export var max_roll_speed = 600.0     # Speed cap when rolling downhill
@onready var components: Node2D = $Components
@onready var animated_sprite = $Components/AnimatedSprite2D
@onready var wing_sprite: Sprite2D = $Components/WingSprite
@onready var dirt: CPUParticles2D = $Components/Dirt

signal stamina_changed

var active: bool = true
var jumps: int = 0
var direction: float = 1.0
var stamina: float = max_stamina
var stamina_delay_timer: float = 0.0

func _ready():
	# Stick to the ground when rolling down slopes instead of hopping off
	floor_snap_length = 8.0

func use_stamina(amount: int) -> void:
	stamina = max(stamina - amount, 0)
	stamina_delay_timer = stamina_recharge_delay # Reset the delay clock
	stamina_changed.emit()

func _process(delta) -> void:
	if stamina_delay_timer > 0:
		stamina_delay_timer -= delta
	else:
		if stamina < max_stamina:
			stamina = min(stamina + (stamina_recharge_rate * delta), max_stamina)
			stamina_changed.emit()
func _physics_process(delta):
	# Capture pedal event and set timer
	if Input.is_action_just_pressed("pedal"):
		pedal_buffer_timer = pedal_buffer_duration
		use_stamina(pedal_stamina_cost)
	if pedal_buffer_timer > 0.0:
		pedal_buffer_timer -= delta

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

	if active==true:
		if Input.is_action_just_pressed("jump") && jumps < max_jumps && is_on_floor():
			jump(jump_force)
			jumps += 1

		# Facing: only change when left/right is pressed; no velocity from this
		var input_dir = Input.get_axis("move_left", "move_right")
		if input_dir != 0.0:
			direction = sign(input_dir)
			# Use abs() to keep the original scale size, then multiply by the direction (-1 or 1)
			components.scale.x = abs(components.scale.x) * direction

		# Slope: normal.x is positive when the ground descends to the right
		var slope_pull = 0.0
		if is_on_floor():
			slope_pull = get_floor_normal().x * gravity * slope_gravity_scale
		var rolling_downhill = abs(slope_pull) > 1.0 && velocity.x * slope_pull >= 0.0

		# horizontal movement
		# Pedaling only adds speed: if already faster than speed in the facing direction, coast instead
		var pedaling = pedal_buffer_timer > 0.0
		if pedaling:
			dirt.emitting = true # configured for one-shot
		if pedaling && stamina > 0 && velocity.x * direction < speed:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		elif !rolling_downhill:
			velocity.x = move_toward(velocity.x, 0, friction * delta)

		velocity.x += slope_pull * delta
		velocity.x = clamp(velocity.x, -max_roll_speed, max_roll_speed)

	move_and_slide()
	update_animations(direction)

func jump(force):
	AudioPlayer.play_sfx("jump")
	velocity.y = -force

func update_animations(_animation_direction):
	if is_on_floor():
		# peddling
		if pedal_buffer_timer > 0.0 && stamina > 0.0:
			animated_sprite.play("riding")
		else:
			animated_sprite.pause()
	else:
		if velocity.y < 0:
			# jump
			animated_sprite.play("jump")
		#else:
			# fall
			#animated_sprite.play("fall")

func reward(reward_type: String):
	if reward_type == "wing":
		wing_sprite.visible = true
		max_jumps = 4
