class_name DialogueManager
extends StateMachine

@onready var dialogue_panel: Panel = $DialoguePanel
@onready var response_panel: Control = $ResponsePanel

@onready var dialogue_label: Label = $DialoguePanel/DialogueLabel
@onready var speaker_thumbnail_texture: TextureRect = $DialoguePanel/SpeakerThumbnailTexture
@onready var left_option_button: Button = $ResponsePanel/LeftOptionButton
@onready var right_option_button: Button = $ResponsePanel/RightOptionButton

var _current_dialogue_index: int = 0

@export var _dialogue_interaction_data : DialogueInteractionData
@export var _speaker_icon_dictionary : Dictionary[String, Texture]

var dialogue_interaction_data: DialogueInteractionData:
	get:
		return _dialogue_interaction_data
	set(val):
		_dialogue_interaction_data = val
		_current_dialogue_index = 0
		if not dialogue_interaction_data.music.is_empty():
			MusicManager.set_bgm_and_play(dialogue_interaction_data.music)
		begin_dialogue_interaction()


func _ready() -> void:
	super._ready()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if get_current_state_name() == "DialogueState":
			_advance_dialogue_interaction()


func _advance_dialogue_interaction():
	_current_dialogue_index = _current_dialogue_index + 1
	if _current_dialogue_index < dialogue_interaction_data.dialogue.size():
		display_dialogue_at_current_index()
	else:
		transition_to_state("ResponseState")


func begin_dialogue_interaction():
	_current_dialogue_index = 0
	display_dialogue(dialogue_interaction_data.dialogue[_current_dialogue_index].text)
	transition_to_state("DialogueState")


func display_dialogue_at_current_index():
		display_dialogue(dialogue_interaction_data.dialogue[_current_dialogue_index].text)
		var new_texture = _speaker_icon_dictionary[dialogue_interaction_data.dialogue[_current_dialogue_index].speaker]
		if new_texture == null:
			speaker_thumbnail_texture.visible = false
		else:
			speaker_thumbnail_texture.visible = true
			speaker_thumbnail_texture.texture = new_texture
		


func display_dialogue(text: String):
	dialogue_label.text = text
	

func show_dialogue_panel():
	dialogue_panel.visible = true
	response_panel.visible = false


func show_response_panel():
	dialogue_panel.visible = false
	response_panel.visible = true
	populate_response_buttons_with_data()


func populate_response_buttons_with_data():
	left_option_button.text = dialogue_interaction_data.responses[0].text
	right_option_button.text = dialogue_interaction_data.responses[1].text


func handle_response(response: ResponseData):
	match response.type:
		ResponseData.ResponseType.CHANGE_SCENE:
			SceneManager.load_scene(response.payload)
			
		ResponseData.ResponseType.NEW_DIALOGUE:
			dialogue_interaction_data = GameManager.interaction_dictionary[response.payload]


func on_left_option_selected():
	handle_response(dialogue_interaction_data.responses[0])


func on_right_option_selected():
	handle_response(dialogue_interaction_data.responses[1])
	
