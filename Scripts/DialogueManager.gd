class_name DialogueManager
extends StateMachine

@onready var dialogue_panel: Panel = $DialoguePanel
@onready var response_panel: Panel = $ResponsePanel

@onready var dialogue_label: Label = $DialoguePanel/DialogueLabel
@onready var left_option_button: Button = $ResponsePanel/LeftOptionButton
@onready var right_option_button: Button = $ResponsePanel/RightOptionButton

var _current_dialogue_index: int = 0

@export var _dialogue_interaction_data : DialogueInteractionData

var dialogue_interaction_data: DialogueInteractionData:
	get:
		return _dialogue_interaction_data
	set(val):
		_dialogue_interaction_data = val
		begin_dialogue_interaction()


func _ready() -> void:
	super._ready()
	begin_dialogue_interaction()


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
	display_dialogue(dialogue_interaction_data.dialogue[_current_dialogue_index])
	transition_to_state("DialogueState")


func display_dialogue_at_current_index():
		display_dialogue(dialogue_interaction_data.dialogue[_current_dialogue_index])


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
	left_option_button.text = dialogue_interaction_data.responses[0].response_text
	right_option_button.text = dialogue_interaction_data.responses[1].response_text


func handle_response(response: ResponseData):
	match response.type:
		ResponseData.ResponseType.CHANGE_SCENE:
			get_tree().change_scene_to_packed(response.payload)
			
		ResponseData.ResponseType.NEW_DIALOGUE:
			dialogue_interaction_data = response.payload


func on_left_option_selected():
	handle_response(dialogue_interaction_data.responses[0])


func on_right_option_selected():
	handle_response(dialogue_interaction_data.responses[1])
	
