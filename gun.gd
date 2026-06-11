extends Node2D

@export var projectile_scene: PackedScene
@export var fire_rate: float = 0.2

var can_fire: bool = true

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot") and can_fire:
		shoot()

func shoot() -> void:
	if not projectile_scene:
		return
		
	can_fire = false
	
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	
	projectile.global_position = $Muzzle.global_position
	
	
	var global_dir = $Muzzle.global_position.direction_to(get_global_mouse_position()).normalized()
	projectile.direction = global_dir
	
	
	projectile.global_rotation = global_dir.angle()
	
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
