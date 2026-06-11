extends Control

@onready var restart_button: Button = $VBoxContainer/Button

func _ready() -> void:
	if restart_button:
		if restart_button.pressed.is_connected(_on_restart_button_pressed):
			restart_button.pressed.disconnect(_on_restart_button_pressed)
		
		restart_button.pressed.connect(_on_restart_button_pressed)

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
