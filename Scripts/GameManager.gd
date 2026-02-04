extends Node

@export var dialogue_interactions: Array[DialogueInteractionData]
@export var starting_dialogue_interaction: DialogueInteractionData
@export var lvl_1_buff: BuffData
@export var lvl_2_buff: BuffData
@export var lvl_3_buff: BuffData


var interaction_dictionary: Dictionary


func _ready():
	for interaction in dialogue_interactions:
		interaction_dictionary[interaction.id] = interaction


func transition_to_bullet_hell(payload):
	SceneManager.load_scene(payload)
	await get_tree().scene_changed
	var lvl = get_tree().get_first_node_in_group("level_manager")
	if str(payload).ends_with("mask"):
		lvl.initialize(lvl_1_buff)


func transition_to_dialogue(data: DialogueInteractionData):
	var dialogue_scene = SceneManager.scene_dictionary["Dialogue"]
	get_tree().change_scene_to_packed(dialogue_scene)
	await get_tree().scene_changed
	get_tree().current_scene.dialogue_interaction_data = data
	

func start_game():
	var dialogue_scene = SceneManager.scene_dictionary["Dialogue"]
	get_tree().change_scene_to_packed(dialogue_scene)
	await get_tree().scene_changed
	get_tree().current_scene.dialogue_interaction_data = starting_dialogue_interaction
	print(starting_dialogue_interaction.dialogue.size())
