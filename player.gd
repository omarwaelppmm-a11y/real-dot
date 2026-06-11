extends CharacterBody2D

@export var speed: float = 300.0
@export var max_health: float = 40.0
@export var wave_frequency: float = 25.0  

@onready var head: Polygon2D = $head
@onready var body: Polygon2D = $body
@onready var stripe_1: ColorRect = $Stripe1
@onready var stripe_2: ColorRect = $Stripe2

@onready var wing_left: ColorRect = $WingLeft
@onready var wing_right: ColorRect = $WingRigh

@onready var eye_right: ColorRect = $"eye right"
@onready var eye_left: ColorRect = $"eye left"

@onready var game_over_screen: Control = get_node_or_null("../CanvasLayer/GameOverScreen")
@onready var health_bar: ProgressBar = get_node_or_null("../CanvasLayer/HealthBar")
@onready var catch_up_bar: ProgressBar = get_node_or_null("../CanvasLayer/CatchUpBar")
@onready var health_text_label: Label = get_node_or_null("../CanvasLayer/HealthBar/HealthText")

@onready var pipes_text_label: Label = get_node_or_null("../CanvasLayer/PipesText")

var current_health: float
var time_passed: float = 0.0

var pipes_score: int = 0

func _ready() -> void:
	current_health = max_health
	
	if is_instance_valid(game_over_screen):
		game_over_screen.hide()
		
	if is_instance_valid(health_bar):
		health_bar.max_value = max_health
		health_bar.value = current_health
		
	if is_instance_valid(catch_up_bar):
		catch_up_bar.max_value = max_health
		catch_up_bar.value = current_health

	update_health_ui()
	update_pipes_ui()

func _process(delta: float) -> void:
	if velocity.length() > 0:
		time_passed += delta
		var flap_modifier := sin(time_passed * wave_frequency)
		
		if is_instance_valid(wing_left):
			wing_left.scale.y = flap_modifier
		if is_instance_valid(wing_right):
			wing_right.scale.y = flap_modifier
	else:
		if is_instance_valid(wing_left):
			wing_left.scale.y = 1.0
		if is_instance_valid(wing_right):
			wing_right.scale.y = 1.0
			
	if is_instance_valid(catch_up_bar) and is_instance_valid(health_bar):
		catch_up_bar.value = lerp(catch_up_bar.value, health_bar.value, 5.0 * delta)

func take_damage(amount: float) -> void:
	current_health -= amount
	current_health = max(0.0, current_health)
	
	update_health_ui()
	
	if current_health <= 0:
		die()

func add_pipe() -> void:
	pipes_score += 1
	update_pipes_ui()

func update_health_ui() -> void:
	if is_instance_valid(health_bar):
		health_bar.value = current_health
		
	if is_instance_valid(health_text_label):
		health_text_label.text = str(ceil(current_health)) + "H"

func update_pipes_ui() -> void:
	if is_instance_valid(pipes_text_label):
		pipes_text_label.text = "Pipes: " + str(pipes_score)

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	
	if direction.x != 0:
		transform.x.x = sign(direction.x)
		
	move_and_slide()

func die() -> void:
	if is_instance_valid(game_over_screen):
		game_over_screen.show()
	get_tree().paused = true
