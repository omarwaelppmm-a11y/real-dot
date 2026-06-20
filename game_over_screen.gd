extends Control

@onready var restart_button: Button = $VBoxContainer/Button
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton

func _ready() -> void:
	if restart_button:
		if restart_button.pressed.is_connected(_on_restart_button_pressed):
			restart_button.pressed.disconnect(_on_restart_button_pressed)
		restart_button.pressed.connect(_on_restart_button_pressed)
		
	if main_menu_button:
		if main_menu_button.pressed.is_connected(_on_main_menu_button_pressed):
			main_menu_button.pressed.disconnect(_on_main_menu_button_pressed)
		main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
