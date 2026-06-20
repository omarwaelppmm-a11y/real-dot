extends Area2D

@export var heal_amount: float = 10.0

@onready var lifespan_timer: Timer = $LifespanTimer

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	lifespan_timer.timeout.connect(_on_lifespan_timeout)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.current_health = min(body.max_health, body.current_health + heal_amount)
			body.update_health_ui()
		queue_free()

func _on_lifespan_timeout() -> void:
	queue_free()
