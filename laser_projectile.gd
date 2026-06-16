extends Area2D

@export var speed: float = 800.0
@export var instant_damage: float = 9999.0
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)
	
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player" and body.has_method("take_damage"):
		body.take_damage(instant_damage)
