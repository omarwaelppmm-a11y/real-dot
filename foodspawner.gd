extends Timer

@export var food_scene: PackedScene = preload("res://food.tscn")

var map_min_x: float = 20.0
var map_max_x: float = 1133.0
var map_min_y: float = 20.0
var map_max_y: float = 647.0

func _ready() -> void:
	timeout.connect(_on_timeout)

func _on_timeout() -> void:
	var food_instance = food_scene.instantiate()
	
	var random_x = randf_range(map_min_x, map_max_x)
	var random_y = randf_range(map_min_y, map_max_y)
	food_instance.global_position = Vector2(random_x, random_y)
	
	get_parent().add_child(food_instance)
