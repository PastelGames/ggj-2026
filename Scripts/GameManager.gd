extends Node

@export var dialogue_interactions: Array[DialogueInteractionData]
@export var starting_dialogue_interaction: DialogueInteractionData

var interaction_dictionary: Dictionary


func _ready():
	for interaction in dialogue_interactions:
		interaction_dictionary[interaction.id] = interaction


func start_game():
	var dialogue_scene = SceneManager.scene_dictionary["Dialogue"]
	get_tree().change_scene_to_packed(dialogue_scene)
	await get_tree().scene_changed
	get_tree().current_scene.dialogue_interaction_data = starting_dialogue_interaction
	print(starting_dialogue_interaction.dialogue.size())
