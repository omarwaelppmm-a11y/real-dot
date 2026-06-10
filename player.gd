extends CharacterBody2D

@export var speed: float = 300.0
@export var max_health: float = 100.0

@export var rotation_speed: float = 4.0
@export var wave_frequency: float = 15.0  
@export var wave_amplitude: float = 0.08  
@export var jitter_intensity: float = 2.0  

@onready var sprite: Sprite2D = $Sprite2D
@onready var game_over_screen: Control = $"../CanvasLayer/GameOverScreen"

var current_health: float
var time_passed: float = 0.0
var original_sprite_scale: Vector2

func _ready() -> void:
	current_health = max_health
	if sprite:
		original_sprite_scale = sprite.scale
	
	if game_over_screen:
		game_over_screen.hide()

func _process(delta: float) -> void:
	if sprite:
		time_passed += delta
		
		sprite.rotation += rotation_speed * delta
		
		var wave_modifier := sin(time_passed * wave_frequency) * wave_amplitude
		sprite.scale = original_sprite_scale + Vector2(wave_modifier, -wave_modifier)
		
		sprite.position = Vector2(
			randf_range(-jitter_intensity, jitter_intensity),
			randf_range(-jitter_intensity, jitter_intensity)
		)

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

func take_damage(amount: float) -> void:
	current_health -= amount
	print("💥 Player hit! Health remaining: ", int(current_health))
	
	if current_health <= 0:
		die()

func die() -> void:
	print("💀 Player has died!")
	
	if game_over_screen:
		game_over_screen.show()
	
	get_tree().paused = true
