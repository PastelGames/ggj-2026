extends CharacterBody2D

signal died

@export var friction = 1000.0
@export var acceleration = 1000.0
@export var bullet_scene: PackedScene
@export var speed = 300.0
@export var shot_cd = 0.10
@export var strength = 1
@export var bullet_speed = 600.0
@export var max_hp = 10

var hp
var invuln = false
var bullet_parent: Node = null

@onready var hitbox: Area2D = $Hitbox
@onready var shoot_timer: Timer = $ShotTimer
@onready var invuln_timer: Timer = $InvulnTimer
@onready var shot_origin: Marker2D = $ShootPositionMarker

var direction = Vector2.ZERO
var target_velocity = Vector2.ZERO
var shot_direction = Vector2.ZERO

func _ready() -> void:

	hp = max_hp
	shoot_timer.wait_time = shot_cd
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	invuln_timer.timeout.connect(_on_invuln_timeout)
	hitbox.area_entered.connect(_on_hitBox_entered)

func _physics_process(delta: float) -> void:
	
	
	# movement input
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	velocity = (direction.normalized() * speed)
	
	# below is acceleration & friction
	#target_velocity = (direction.normalized() * speed)
	'''
	if direction != Vector2.ZERO:
		velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
		velocity.y = move_toward(velocity.y, target_velocity.y, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.y = move_toward(velocity.y, 0, friction * delta)
	velocity = velocity.clampf(-speed,speed)
	'''
	
	# move and reset direction for next physics tick
	move_and_slide()
	look_at(get_global_mouse_position())
	direction = Vector2.ZERO

func _on_shoot_timer_timeout() -> void:
	if not Input.is_action_pressed("shoot"):
		return
	if bullet_scene == null:
		return
	
	var b = bullet_scene.instantiate()
	bullet_parent.add_child(b)
	b.global_position = shot_origin.global_position
	b.direction = Vector2.from_angle(rotation).normalized()
	b.damage = strength
	b.speed = bullet_speed
	
func _on_hitBox_entered(area : Area2D) -> void:
	if invuln:
		return
	
	var parent := area.get_parent()
	if parent and parent.is_in_group("enemy_bullets"):
		hp -= parent.damage
		parent.queue_free()
		
	if hp <= 0:
		_die()

func _die() -> void:
	invuln = true
	emit_signal("died")
	invuln_timer.start()

func _on_invuln_timeout() -> void:
	invuln = false
	
func apply_buff(input_buff_data : BuffData) -> void:
	var extra_speed = 100
	var extra_strength = 1
	var extra_hp = 3
	
	if input_buff_data.BuffName == "speed":
		speed = speed + extra_speed
		if input_buff_data.BuffDuration > 0:
			await get_tree().create_timer(input_buff_data.BuffDuration).timeout
			speed = speed - extra_speed
		
	if input_buff_data.BuffName == "strength":
		strength = strength + extra_strength
		if input_buff_data.BuffDuration > 0:
			await get_tree().create_timer(input_buff_data.BuffDuration).timeout
			strength = strength - extra_strength
	
	if input_buff_data.BuffName == "resistance":
		hp = hp + extra_hp
