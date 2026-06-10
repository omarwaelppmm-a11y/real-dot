extends Control

# Fixed the path since VBoxContainer is a direct child of GameOverScreen
@onready var restart_button: Button = $VBoxContainer/Button

func _ready() -> void:
	if restart_button:
		if restart_button.pressed.is_connected(_on_restart_button_pressed):
			restart_button.pressed.disconnect(_on_restart_button_pressed)
		
		restart_button.pressed.connect(_on_restart_button_pressed)
		print("✅ Restart button successfully bound!")
	else:
		push_error("❌ Critical: Restart button node path not found!")

func _on_restart_button_pressed() -> void:
	print("🔄 Restart button clicked! Unpausing and reloading...")
	get_tree().paused = false
	get_tree().reload_current_scene()
