extends HSlider




func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
