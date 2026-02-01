extends Node2D

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

var bullet_parent: Node = null
var player_location: Vector2 = Vector2.ZERO
var player: Node = null

@onready var spawns: Array[Node] = [$EnemySpawn/Spawn1, $EnemySpawn/Spawn2,
	$EnemySpawn/Spawn3, $EnemySpawn/Spawn4, $EnemySpawn/Spawn5]	
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var enemy_spawn: Marker2D = $EnemySpawn
@onready var bullets_player: Node2D = $BulletContainer_Player
@onready var bullets_enemy: Node2D = $BulletContainer_Enemy
@onready var enemies: Node2D = $EnemyContainer

func _physics_process(delta: float) -> void:
	player_location = player.global_position

func _ready() -> void:
	_spawn_player()
	$EnemySpawnTimer.timeout.connect(_spawn_enemy)
	$EnemySpawnTimer.start()
	$DifficultyTimer.timeout.connect(_difficulty_increase)
	$DifficultyTimer.start()

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
	var spawn_number = randi_range(0,4)
	var s = spawns.get(spawn_number)
	e.global_position = s.global_position
	
	var shooter := e.get_node_or_null("Shooter")
	if shooter:
		shooter.bullet_container_path = bullets_enemy.get_path()

func _on_player_died() -> void:
	get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"):
		#get_node("CanvasLayer").global_position = player.global_position
		get_tree().paused = true
		get_node("CanvasLayer/PausePanel").show()
		
func _difficulty_increase() -> void:
	if ($EnemySpawnTimer.wait_time > 1.0):
		$EnemySpawnTimer.wait_time -= 0.5
