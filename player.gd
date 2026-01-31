extends CharacterBody2D


const SPEED = 300.0
const FRICTION = 100.0
const ACC = 50.0

var direction = Vector2.ZERO
var target_velocity = Vector2.ZERO
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	target_velocity = (direction.normalized() * SPEED)
	
	if direction != Vector2.ZERO:
		velocity.x = move_toward(velocity.x, target_velocity.x, ACC * delta)
		velocity.y = move_toward(velocity.y, target_velocity.y, ACC * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
	velocity = velocity.clampf(-SPEED,SPEED)

	move_and_slide()
	direction = Vector2.ZERO
