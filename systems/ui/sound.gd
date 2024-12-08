extends HSlider


func _on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(0, new_value)
