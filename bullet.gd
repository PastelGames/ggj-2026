extends CharacterBody2D

@export var speed: float = 400.0
@export var despawn_time: float = 4.0

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# despawn on timer
	get_tree().create_timer(despawn_time).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	velocity = direction * speed

	# move_and_collide gives us immediate impact handling (great for walls)
	var collision := move_and_collide(velocity * delta)
	if collision:
		# If we hit anything on our physics mask (walls/targets), despawn.
		queue_free()
# Called when the node enters the scene tree for the first time.
