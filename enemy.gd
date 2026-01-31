extends CharacterBody2D

signal killed

@export var max_hp: int = 4
var hp: int

@onready var hurtbox: Area2D = $Hurtbox

func _ready() -> void:
	hp = max_hp
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:

	var parent := area.get_parent()
	
	# take damage and destroy bullet if parent is Player_Bullet
	if parent and parent.is_in_group("player_bullets"):
		hp -= 1
		parent.queue_free()

		if hp <= 0:
			emit_signal("killed")
			queue_free()
