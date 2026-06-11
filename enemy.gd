extends CharacterBody2D

@export var speed: float = 120.0
@export var damage_per_second: float = 20.0
@export var max_health: float = 30.0 

@onready var hitbox: Area2D = $Hitbox

var player: Node2D = null
var current_health: float 

func _ready() -> void:
	player = get_node_or_null("/root/Main/Player")
	current_health = max_health 

func _physics_process(delta: float) -> void:
	if player:
		var direction := global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
		if hitbox.has_overlapping_bodies():
			for body in hitbox.get_overlapping_bodies():
				if body.name == "Player" and body.has_method("take_damage"):
					body.take_damage(damage_per_second * delta)

func take_damage(amount: float) -> void:
	current_health -= amount
	
	if current_health <= 0:
		die()

func die() -> void:
	
	if is_instance_valid(player) and player.has_method("add_pipe"):
		player.add_pipe()
	queue_free()
