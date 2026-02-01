extends Node2D
class_name BulletHellManager

func _initialize(buffs: BuffData) -> void:
	MusicManager.set_bgm_and_play("Dungeon")
	return

func _on_success() -> void:
	return
	
func _on_fail() -> void:
	return
