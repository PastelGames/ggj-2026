class_name DialogueEntry
extends Resource

@export var speaker : String
@export var text : String

func initialize(p_speaker: String, p_text: String):
	speaker = p_speaker
	text = p_text
