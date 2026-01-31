extends Node

@export var bullet_scene: PackedScene
@export var bullet_container_path: NodePath
@export var bullet_speed: float = 220.0
@export var fire_interval: float = 0.8

var direction: Vector2 = Vector2.ZERO
var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = false
	_timer.wait_time = fire_interval
	add_child(_timer)
	_timer.timeout.connect(_fire_one)
	_timer.start()

func _fire_one() -> void:
	if bullet_scene == null:
		return
	
	var container: Node = null
	if bullet_container_path != NodePath(""):
		container = get_node_or_null(bullet_container_path)
	if container == null:
		container = get_tree().current_scene
	
	var origin := (get_parent() as Node2D).global_position

	var b := bullet_scene.instantiate()
	container.add_child(b)
	b.global_position = origin
	b.speed = bullet_speed
	b.direction = direction
