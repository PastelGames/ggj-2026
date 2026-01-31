extends Node

@export var bullet_scene: PackedScene
@export var bullet_speed: float = 220.0
@export var fire_interval: float = 0.8

var bullet_parent: Node = null

var _timer: Timer

func _ready() -> void:
	bullet_parent = get_parent().bullet_parent
	_timer = Timer.new()
	_timer.one_shot = false
	_timer.wait_time = fire_interval
	add_child(_timer)
	_timer.timeout.connect(_fire_one)
	_timer.start()

func _fire_one() -> void:
	if bullet_scene == null:
		return

	

	var origin := (get_parent() as Node2D).global_position

	var b := bullet_scene.instantiate()
	bullet_parent.add_child(b)
	b.global_position = origin
	b.speed = bullet_speed
