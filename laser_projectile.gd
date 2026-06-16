extends Area2D

@export var speed: float = 900.0
@export var damage: float = 35.0

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		return
		
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
