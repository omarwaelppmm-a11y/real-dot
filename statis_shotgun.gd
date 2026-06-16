extends Node2D

@export var laser_scene: PackedScene = preload("res://laser_projectile.tscn")
@export var fire_rate: float = 1.5

var can_fire: bool = true

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot") and can_fire:
		fire_stasis_laser()

func fire_stasis_laser() -> void:
	if not laser_scene:
		return
		
	can_fire = false
	
	var laser = laser_scene.instantiate()
	get_tree().current_scene.add_child(laser)
	
	laser.global_position = $Muzzle.global_position
	
	var global_dir = $Muzzle.global_position.direction_to(get_global_mouse_position()).normalized()
	laser.direction = global_dir
	laser.global_rotation = global_dir.angle()
	laser.scale = Vector2(3.0, 3.0) 
	
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
