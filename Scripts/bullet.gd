extends CharacterBody2D

@export var speed: float = 400.0
@export var despawn_time: float = 10.0
@export var damage = 1


var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# despawn on timer
	get_tree().create_timer(despawn_time).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	rotation = velocity.angle()

	var collision := move_and_collide(velocity * delta)
	if collision:
		# If we hit wall
		queue_free()
