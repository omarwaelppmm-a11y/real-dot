extends CharacterBody2D

@export var speed: float = 120.0
@export var damage_per_second: float = 20.0

@onready var hitbox: Area2D = $Hitbox

var player: Node2D = null

func _ready() -> void:
	player = get_node_or_null("/root/Main/Player")

func _physics_process(delta: float) -> void:
	if player:
		# 1. Track movement toward the player
		var direction: Vector2 = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
		
		# 2. Check for damage contact
		if hitbox.has_overlapping_bodies():
			for body in hitbox.get_overlapping_bodies():
				if body.name == "Player" and body.has_method("take_damage"):
					# Multiply by delta so damage scales accurately over continuous time
					body.take_damage(damage_per_second * delta)
