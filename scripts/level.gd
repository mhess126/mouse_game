extends Node2D

@export var next_level: PackedScene = null
@export var is_final_level: bool = false

@onready var start = $LevelStructure/Features/Start
@onready var exit = $LevelStructure/Features/Exit
@onready var death_zone = $Deathzone

@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer

var player = null

@export var level_time = 5

var timer_node = null
var time_left

var win = false

func _ready():
	AudioPlayer.play_music()

	player = get_tree().get_first_node_in_group("player")
	if player!=null:
		player.global_position = start.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps")
	var rewards = get_tree().get_nodes_in_group("rewards")
	
	for trap in traps:
		#trap.connect("touched_player", _on_trap_touched_player)
		trap.touched_player.connect(_on_trap_touched_player)
	
	for reward_item in rewards:
		print(reward_item)
		reward_item.touched_player.connect(_on_reward_touched_player.bind(reward_item))
	
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_deathzone_body_entered)
	hud.set_stamina_meter(player.stamina)

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_deathzone_body_entered(_body):
	AudioPlayer.play_sfx("hurt")
	reset_player()

func _on_trap_touched_player():
	AudioPlayer.play_sfx("hurt")
	reset_player()

func _on_reward_touched_player(emitter: Reward):
	AudioPlayer.play_sfx("hurt")
	if emitter.type == "wing":
		player.reward("wing")
	elif emitter.type == "propeller":
		player.reward("propeller")

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()

func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || (next_level != null):
			exit.animate()
			player.active = false
			win = true
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)

func _on_player_stamina_changed(value: int) -> void:
	hud.set_stamina_meter(value)
	pass # Replace with function body.
