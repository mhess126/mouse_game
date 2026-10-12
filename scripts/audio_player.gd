extends Node

var hurt = preload("res://assets/audio/hurt.wav")
var jump = preload("res://assets/audio/jump.wav")
var pedal = preload("uid://cext80de6wr4o")

@onready var music_player: AudioStreamPlayer = $MusicPlayer

func play_music() -> void:
	#music_player.play()
	pass
	
func play_sfx(sfx_name: String):
	var stream = null
	if sfx_name == "hurt":
		stream = hurt
	elif sfx_name == "jump":
		stream = jump
#	elif sfx_name == "pedal":
#		stream = pedal
	else:
		print("Invalid sfx name")
		return
	
	var asp = AudioStreamPlayer.new()
	asp.stream = stream
	asp.name = "SFX"
	
	add_child(asp)
	
	asp.play()
	
	await asp.finished
	asp.queue_free()
