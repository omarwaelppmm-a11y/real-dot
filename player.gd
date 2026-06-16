extends CharacterBody2D

@export var speed: float = 300.0
@export var max_health: float = 40.0
@export var wave_frequency: float = 25.0  

@export var dash_speed: float = 1000.0
@export var dash_duration: float = 0.3
@export var dash_cooldown: float = 6.0
@export var ghost_spawn_interval: float = 0.05

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

@onready var default_gun: Node2D = $Gun
@onready var statis_shotgun: Node2D = $"statis shotgun"

var current_health: float
var time_passed: float = 0.0

var pipes_score: int = 0

var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: Vector2 = Vector2.ZERO

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
	update_weapon_visibility(false)

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

func update_weapon_visibility(shotgun_unlocked: bool) -> void:
	if is_instance_valid(statis_shotgun) and is_instance_valid(default_gun):
		if shotgun_unlocked:
			statis_shotgun.visible = true
			statis_shotgun.set_process(true)
			default_gun.visible = false
			default_gun.set_process(false)
		else:
			statis_shotgun.visible = false
			statis_shotgun.set_process(false)
			default_gun.visible = true
			default_gun.set_process(true)

func swap_to_laser() -> void:
	update_weapon_visibility(true)

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
	if is_dashing:
		velocity = dash_direction * dash_speed
	else:
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * speed
		
		if direction.x != 0:
			var target_scale_x = sign(direction.x)
			if is_instance_valid(head): head.scale.x = target_scale_x
			if is_instance_valid(body): body.scale.x = target_scale_x
			
		if Input.is_action_just_pressed("dash") and can_dash and direction != Vector2.ZERO:
			start_dash(direction)
			
	move_and_slide()

func start_dash(dir: Vector2) -> void:
	is_dashing = true
	can_dash = false
	dash_direction = dir.normalized()
	
	start_cooldown_timer()
	spawn_ghosts_loop()
	
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false

func spawn_ghosts_loop() -> void:
	while is_dashing:
		create_ghost_instance()
		await get_tree().create_timer(ghost_spawn_interval).timeout

func create_ghost_instance() -> void:
	var ghost = Node2D.new()
	ghost.global_position = global_position
	
	for child in get_children():
		if child is Polygon2D or child is ColorRect:
			var duplicate_child = child.duplicate()
			ghost.add_child(duplicate_child)
			
	get_parent().add_child(ghost)
	
	ghost.modulate = Color(0.3, 0.6, 1.0, 0.6)
	
	var tween = create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, 0.3)
	tween.tween_callback(ghost.queue_free)

func start_cooldown_timer() -> void:
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func die() -> void:
	if is_instance_valid(game_over_screen):
		game_over_screen.show()
	get_tree().paused = true
