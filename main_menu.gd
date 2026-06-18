extends Control

@onready var master_bus_index = AudioServer.get_bus_index("Master")

# 1. Export variables for the scene path and the UI nodes
@export_file("*.tscn") var gameplay_scene_path: String = ""
@export var start_button: Button
@export var volume_slider: HSlider

func _ready() -> void:
	get_tree().paused = false
	
	# 2. Safety check: ensure you assigned the nodes in the Inspector
	if is_instance_valid(start_button):
		start_button.pressed.connect(_on_start_pressed)
	else:
		push_error("MainMenu Error: Start Button is not assigned in the Inspector!")
		
	if is_instance_valid(volume_slider):
		volume_slider.value_changed.connect(_on_volume_changed)
	else:
		push_error("MainMenu Error: Volume Slider is not assigned in the Inspector!")

func _on_start_pressed() -> void:
	if gameplay_scene_path != "" and ResourceLoader.exists(gameplay_scene_path):
		get_tree().paused = false
		get_tree().change_scene_to_file(gameplay_scene_path)
	else:
		push_error("MainMenu Error: Gameplay scene path is empty or invalid!")

func _on_volume_changed(value: float) -> void:
	if value <= -39:
		AudioServer.set_bus_mute(master_bus_index, true)
	else:
		AudioServer.set_bus_mute(master_bus_index, false)
		AudioServer.set_bus_volume_db(master_bus_index, value)
