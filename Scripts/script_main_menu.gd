extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.set_bgm_and_play("Intro")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	GameManager.start_game()


func _on_setting_button_pressed() -> void:
	get_node("Setting").show()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
