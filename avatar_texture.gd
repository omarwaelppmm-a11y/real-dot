extends TextureRect

func _ready():
	var tween = create_tween().set_loops()
	var original_y = position.y
	var move_distance = 15.0
	var duration = 2.0
	
	tween.tween_property(self, "position:y", original_y + move_distance, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", original_y, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
