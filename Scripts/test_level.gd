extends Node2D

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

var bullet_parent: Node = null
var player_location: Vector2 = Vector2.ZERO
var player: Node = null
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var enemy_spawn: Marker2D = $EnemySpawn
@onready var bullets_player: Node2D = $BulletContainer_Player
@onready var bullets_enemy: Node2D = $BulletContainer_Enemy
@onready var enemies: Node2D = $EnemyContainer

func _physics_process(delta: float) -> void:
	player_location = player.global_position

func _ready() -> void:
	_spawn_player()
	_spawn_enemy()

func _spawn_player() -> void:
	var p := player_scene.instantiate()
	player = p
	add_child(p)
	p.global_position = player_spawn.global_position
	p.bullet_parent = bullets_player
	p.died.connect(_on_player_died)

func _spawn_enemy() -> void:
	var e := enemy_scene.instantiate()
	enemies.add_child(e)
	e.global_position = enemy_spawn.global_position
	
	var shooter := e.get_node_or_null("Shooter")
	if shooter:
		shooter.bullet_container_path = bullets_enemy.get_path()

func _on_player_died() -> void:
	get_tree().reload_current_scene()
