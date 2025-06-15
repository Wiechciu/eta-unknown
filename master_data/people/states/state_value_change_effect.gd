class_name StateValueChangeEffect
extends Control


var tween_duration: float = 1.0


func initialize(state_data: StateDataNew, change_amount: float) -> void:
	var operator_sign: String
	if change_amount > 0:
		operator_sign = "+"
		if state_data.positive_effect:
			$Label.modulate = Color.WHITE
		else:
			$Label.modulate = Color.INDIAN_RED
	elif change_amount < 0:
		operator_sign = "-"
		if state_data.positive_effect:
			$Label.modulate = Color.INDIAN_RED
		else:
			$Label.modulate = Color.WHITE
	else:
		queue_free()
		return
	
	$Label.text = "%s%d" % [operator_sign, absf(change_amount)]
	
	$Label.modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Label, "position:x", 110.0, tween_duration).as_relative()
	tween.set_parallel(true)
	tween.tween_property($Label, "modulate:a", 1.0, tween_duration)
	tween.set_parallel(false)
	tween.tween_property($Label, "modulate:a", 0.0, tween_duration)
	tween.tween_callback(queue_free)
