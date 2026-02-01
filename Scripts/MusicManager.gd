extends Node

@export var track_dictionary: Dictionary[String, AudioStream]

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func set_bgm_and_play(track_key):
	var new_track = track_dictionary[track_key]
	if audio_stream_player.stream != new_track:
		audio_stream_player.stream = new_track
		audio_stream_player.play()
