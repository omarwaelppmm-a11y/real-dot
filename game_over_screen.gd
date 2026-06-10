extends Control

@onready var restart_button: Button = $VBoxContainer/Button

func _ready() -> void:
	restart_button.pressed.connect(_on_restart_button_pressed)

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
