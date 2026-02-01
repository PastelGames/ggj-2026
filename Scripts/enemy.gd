extends CharacterBody2D

signal killed

@export var max_hp: int = 4
@export var speed = 100.0

var player_location: Vector2 = Vector2.ZERO
var hp: int

@onready var hurtbox: Area2D = $Hurtbox

func _ready() -> void:
	hp = max_hp
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	player_location = get_parent().get_parent().player_location
	$Shooter.direction = (player_location - global_position).normalized()
	
	$NavigationAgent2D.target_position = player_location
	var next_path_pos = $NavigationAgent2D.get_next_path_position()
	velocity = global_position.direction_to(next_path_pos) * speed
	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:

	var parent := area.get_parent()
	
	# take damage and destroy bullet if parent is Player_Bullet
	if parent and parent.is_in_group("player_bullets"):
		hp -= parent.damage
		parent.queue_free()

		if hp <= 0:
			emit_signal("killed")
			queue_free()
