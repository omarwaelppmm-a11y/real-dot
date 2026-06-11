extends Area2D

@export var speed: float = 500.0
@export var damage: float = 15.0

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	
	body_entered.connect(_on_body_entered)
	
	
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	
	global_position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	
	if body.is_in_group("Enemies") or body.name.begins_with("Enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free() # Destroy the projectile upon impact
