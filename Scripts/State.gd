class_name State

extends Node

signal transitioned(new_state_name: StringName)

var state_machine : StateMachine

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process_state(delta: float) -> void:
	pass
	
func physics_process_state(delta: float) -> void:
	pass
