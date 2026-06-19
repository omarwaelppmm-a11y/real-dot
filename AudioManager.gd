extends Node

var audio_player: AudioStreamPlayer

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	
	audio_player.stream = load("res://Assets/🎮 Royalty Free Chiptune 8 Bit Music (For Videos) - _Sunset Bridge_ by Purely Grey 🇷🇺.mp3")
	audio_player.bus = "Master"
	audio_player.process_mode = PROCESS_MODE_ALWAYS
	
	var file = audio_player.stream as AudioStreamMP3
	if file:
		file.loop = true
		
	audio_player.play()
