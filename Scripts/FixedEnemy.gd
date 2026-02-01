extends CharacterBody2D

signal killed

@export var max_hp: int = 20
@export var rage_duration : int = 5

var player_location: Vector2 = Vector2.ZERO
var hp: int
var player : Node2D = null

@onready var hurtbox: Area2D = $Hurtbox

func _ready() -> void:
	hp = max_hp
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	var parent := area.get_parent()
	
	# take damage and destroy bullet if parent is Player_Bullet
	if parent and parent.is_in_group("player_bullets"):
		hp -= parent.damage
		parent.queue_free()

		if hp <= 0:
			emit_signal("killed")
			player = get_parent().get_parent().player
			player.apply_rage(rage_duration)
			queue_free()
