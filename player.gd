extends CharacterBody2D

@export var speed: float = 300.0
@export var max_health: float = 100.0

var current_health: float

func _ready() -> void:
	current_health = max_health

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

func take_damage(amount: float) -> void:
	current_health -= amount
	print("💥 Player hit! Health remaining: ", current_health)
	
	if current_health <= 0:
		die()

func die() -> void:
	print("💀 GAME OVER: You died in The Ring!")
	# Temporarily freeze the player or restart the scene
	set_physics_process(false)
