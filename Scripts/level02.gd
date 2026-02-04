extends BulletHellManager

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene
@export var fixed_enemy: PackedScene
@export var player_lives = 1
@export var next_dialogue: DialogueInteractionData

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
@onready var end: Area2D = $EndZone

func _physics_process(delta: float) -> void:
	if player:
		player_location = player.global_position

func initialize(buffs: BuffData) -> void:
	super.initialize(buffs)
	_spawn_player(buffs)
	
func _ready() -> void:
	# For testing
	end.area_entered.connect(_on_end_entered)
	$EnemySpawnTimer.timeout.connect(_spawn_enemy)
	$EnemySpawnTimer.start(2)
	$DifficultyTimer.timeout.connect(_difficulty_increase)
	$DifficultyTimer.start(10)

func _spawn_player(buffs: BuffData) -> void:
	var p := player_scene.instantiate()
	player = p
	p.apply_buff(buffs)
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
	if player_lives < 1:
		_on_fail()
	player_lives -= 1
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"):
		#get_node("CanvasLayer").global_position = player.global_position
		get_tree().paused = true
		get_node("CanvasLayer/PausePanel").show()
		
func _difficulty_increase() -> void:
	if ($EnemySpawnTimer.wait_time > 0.3):
		$EnemySpawnTimer.wait_time -= 0.1
		
func _spawn_fixed() -> void:
	var e := fixed_enemy.instantiate()
	enemies.add_child(e)
	var s = $EnemySpawn/FixedSpawn
	e.global_position = s.global_position

func _on_end_entered(area: Area2D) -> void:
	var parent := area.get_parent()
	
	if parent and parent.is_in_group("player"):
		_on_success()

func _on_success() -> void:
	GameManager.transition_to_dialogue(next_dialogue)
