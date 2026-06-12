extends Control

@onready var pipe_display_label: Label = get_node("VBoxContainer/PanelContainer/HBoxContainer/PipeDisplayLabel")
@onready var buy_fire_rate_btn: Button = get_node("VBoxContainer/HBoxContainer2/card1/VBoxContainer/BuyFireRate")
@onready var buy_damage_btn: Button = get_node("VBoxContainer/HBoxContainer2/card2/VBoxContainer/BuyDamage")

var player: CharacterBody2D = null
var gun: Node2D = null

var fire_rate_cost: int = 5
var damage_cost: int = 5

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	buy_fire_rate_btn.pressed.connect(_on_buy_fire_rate)
	buy_damage_btn.pressed.connect(_on_buy_damage)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_shop"):
		toggle_shop()

func toggle_shop() -> void:
	if visible:
		hide()
		get_tree().paused = false
	else:
		player = get_node_or_null("/root/Main/Player")
		if is_instance_valid(player):
			gun = player.get_node_or_null("Gun")
		
		update_shop_ui()
		show()
		get_tree().paused = true

func update_shop_ui() -> void:
	if is_instance_valid(player) and "pipes" in player:
		pipe_display_label.text = "PIPES: " + str(player.pipes)
	
	buy_fire_rate_btn.text = str(fire_rate_cost) + " PIPES"
	buy_damage_btn.text = str(damage_cost) + " PIPES"

func _on_buy_fire_rate() -> void:
	if not is_instance_valid(player) or not is_instance_valid(gun): return
	if player.pipes >= fire_rate_cost:
		player.pipes -= fire_rate_cost
		gun.fire_rate = max(0.04, gun.fire_rate - 0.02)
		fire_rate_cost = int(fire_rate_cost * 1.5)
		update_shop_ui()

func _on_buy_damage() -> void:
	if not is_instance_valid(player) or not is_instance_valid(gun): return
	if player.pipes >= damage_cost:
		player.pipes -= damage_cost
		if "damage" in gun:
			gun.damage += 5.0
		damage_cost = int(damage_cost * 1.5)
		update_shop_ui()
