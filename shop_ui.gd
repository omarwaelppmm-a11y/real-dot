extends Control

@onready var pipe_display_label: Label = get_node("VBoxContainer/PanelContainer/HBoxContainer/PipeDisplayLabel")
@onready var buy_weapon_btn: Button = get_node("VBoxContainer/HBoxContainer2/card1/VBoxContainer/BuyFireRate")
@onready var buy_damage_btn: Button = get_node("VBoxContainer/HBoxContainer2/card2/VBoxContainer/BuyDamage")

var player: CharacterBody2D = null

var weapon_cost: int = 50
var damage_cost: int = 50
var weapon_unlocked: bool = false

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	buy_weapon_btn.pressed.connect(_on_buy_weapon)
	buy_damage_btn.pressed.connect(_on_buy_damage)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_shop"):
		toggle_shop()

func toggle_shop() -> void:
	if visible:
		hide()
		get_tree().paused = false
	else:
		player = get_tree().get_first_node_in_group("player")
		if not is_instance_valid(player):
			player = get_node_or_null("/root/Main/Player")
		
		update_shop_ui()
		show()
		get_tree().paused = true

func update_shop_ui() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not is_instance_valid(player):
		player = get_node_or_null("/root/Main/Player")
	
	if is_instance_valid(player) and "pipes_score" in player:
		pipe_display_label.text = "PIPES: " + str(player.pipes_score)
	else:
		pipe_display_label.text = "PIPES: 0"
	
	if weapon_unlocked:
		buy_weapon_btn.text = "EQUIPPED"
		buy_weapon_btn.disabled = true
	else:
		buy_weapon_btn.text = "LASER: " + str(weapon_cost) + " PIPES"
		
	buy_damage_btn.text = str(damage_cost) + " PIPES"

func _on_buy_weapon() -> void:
	if not is_instance_valid(player): return
	if player.pipes_score >= weapon_cost and not weapon_unlocked:
		player.pipes_score -= weapon_cost
		player.update_pipes_ui()
		
		weapon_unlocked = true
		if player.has_method("swap_to_laser"):
			player.swap_to_laser()
			
		update_shop_ui()

func _on_buy_damage() -> void:
	if not is_instance_valid(player): return
	var active_gun = player.get_node_or_null("Gun") if not weapon_unlocked else player.get_node_or_null("statis_shotgun")
	if player.pipes_score >= damage_cost and is_instance_valid(active_gun):
		player.pipes_score -= damage_cost
		player.update_pipes_ui()
		if "damage" in active_gun:
			active_gun.damage += 5.0
		damage_cost = int(damage_cost * 1.5)
		update_shop_ui()
