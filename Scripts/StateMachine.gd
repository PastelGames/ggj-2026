class_name StateMachine
extends State

signal initialized

@export var initial_state : State

var _current_state : State
var states: Dictionary = {}


func enter():
	initialize()


func _ready() -> void:
	initialize()


func get_current_state_name() -> StringName:
	if _current_state is StateMachine:
		return _current_state.name + "/" + _current_state.get_current_state_name()
	elif _current_state != null:
		return _current_state.name
	else:
		return ""


func initialize():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
			if not child.transitioned.is_connected(_on_child_transition):
				child.transitioned.connect(_on_child_transition)
		elif child is StateMachine:
			child.initialize()
		else:
			push_warning("state machine contains incompatible child node")
	_current_state = initial_state
	if _current_state != null:
		_current_state.enter()
	
	call_deferred("emit_signal", "initialized")


func _process(delta):
	if _current_state == null:
		return
		
	_current_state.process_state(delta)


func _physics_process(delta):
	if _current_state == null:
		return
	
	_current_state.physics_process_state(delta)


func _on_child_transition(new_state_name: StringName) -> void:
	transition_to_state(new_state_name)


func transition_to_state(new_state_name: StringName):
	var new_state = states.get(new_state_name)
	if new_state == null:
		_current_state.exit()
		_current_state = null
		print("could not find a state with the name ", new_state_name, ". setting state to null")
	elif new_state != _current_state:
		if _current_state != null:
			_current_state.exit()
		new_state.enter()
		_current_state = new_state


func get_state(state_name):
	for child in get_children():
		if child.name == state_name:
			return child
