extends Node

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 700.0

@onready var round_tracker_text: Label = get_node_or_null("../CanvasLayer/RoundTrackerText")
@onready var round_flash_text: Label = get_node_or_null("../CanvasLayer/RoundFlashText")

var player: Node2D = null
var current_round: int = 1
var enemies_spawned_this_round: int = 0
var enemies_killed_this_round: int = 0
var base_enemies_per_round: int = 10
var enemies_to_kill_target: int = 10
var is_round_intermission: bool = false
var spawn_cooldown: float = 2.0
var time_since_last_spawn: float = 0.0

func _ready() -> void:
	player = get_node_or_null("/root/Main/Player")
	start_round_sequence()

func _process(delta: float) -> void:
	if is_round_intermission or not enemy_scene or not is_instance_valid(player):
		return
		
	if enemies_spawned_this_round >= enemies_to_kill_target:
		return

	time_since_last_spawn += delta
	if time_since_last_spawn >= spawn_cooldown:
		time_since_last_spawn = 0.0
		spawn_enemy()

func start_round_sequence() -> void:
	is_round_intermission = true
	enemies_spawned_this_round = 0
	enemies_killed_this_round = 0
	enemies_to_kill_target = base_enemies_per_round + ((current_round - 1) * 5)
	spawn_cooldown = max(0.4, 2.0 - (current_round * 0.15))
	time_since_last_spawn = 0.0
	
	if is_instance_valid(round_tracker_text):
		round_tracker_text.text = "ROUND: " + str(current_round)
		
	if is_instance_valid(round_flash_text):
		round_flash_text.text = "ROUND " + str(current_round) + "\nSTART!"
		round_flash_text.show()
		
	await get_tree().create_timer(2.0).timeout
	
	if is_instance_valid(round_flash_text):
		round_flash_text.hide()
		
	is_round_intermission = false

func spawn_enemy() -> void:
	var random_angle := randf() * PI * 2.0
	var spawn_direction := Vector2(cos(random_angle), sin(random_angle))
	var spawn_position := player.global_position + (spawn_direction * spawn_radius)
	
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = spawn_position
	
	if enemy_instance.has_method("assign_spawner"):
		enemy_instance.assign_spawner(self)
		
	get_tree().current_scene.add_child(enemy_instance)
	enemies_spawned_this_round += 1

func report_enemy_death() -> void:
	enemies_killed_this_round += 1
	if enemies_killed_this_round >= enemies_to_kill_target:
		current_round += 1
		start_round_sequence()
