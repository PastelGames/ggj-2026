extends Node

@export var scene_dictionary: Dictionary[String, PackedScene]

func load_scene(scene_key):
	get_tree().change_scene_to_packed(scene_dictionary[scene_key])
