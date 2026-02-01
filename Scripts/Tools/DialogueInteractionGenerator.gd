@tool
class_name DialogueInteractionGenerator
extends Node

func _ready() -> void:
	generate()


func generate():
	var parser = YAMLParser.new()

	var yfile = FileAccess.open(
					"res://dialogue_v2.yml",
					FileAccess.READ)
	var yaml = yfile.get_as_text()
	yfile.close()

	var result = parser.parse(yaml)
	if typeof(result) == TYPE_DICTIONARY and result.has("interactions"):
		print(result["interactions"])
		var i = 0
		for interaction in result["interactions"]:
			var dialogue_interaction = DialogueInteractionData.new()
			var interaction_id = interaction["interaction_id"]
			print(interaction_id)
			dialogue_interaction.id = interaction_id
			for dialogue in interaction.dialogue:
				dialogue_interaction.dialogue.append(DialogueEntry.new(dialogue["speaker"], dialogue["text"]))
			if interaction.has("responses"):
				for response in interaction.responses:
					var new_response_data = ResponseData.new()
					match response["type"]:
						"goto_dialogue":
							new_response_data.type = ResponseData.ResponseType.NEW_DIALOGUE
						_:
							new_response_data.type = ResponseData.ResponseType.CHANGE_SCENE
					new_response_data.text = response["text"]
					new_response_data.payload = response["payload"]
					dialogue_interaction.responses.append(new_response_data)
			ResourceSaver.save(
				dialogue_interaction,
				"res://Resources/Generated/DialogueInteraction%d.tres" % i)
			i = i + 1
