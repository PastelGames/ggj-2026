extends CharacterBody2D


const SPEED = 300.0
const FRICTION = 100.0
const ACC = 50.0

var direction = Vector2i.ZERO

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	
	move_and_slide()
