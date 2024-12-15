@tool
extends Control


@export var bus_name: StringName = "Master":
	set(value):
		bus_name = value
		label.text = "%s_VOLUME" % value.to_upper()
@export var label: Label
@export var slider: Slider


func _ready() -> void:
	if not Engine.is_editor_hint():
		@warning_ignore("unsafe_method_access")
		GlobalDebugger.assert_all_exported_properties(self)
		
		slider.value_changed.connect(_on_value_changed)


func _on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(new_value))
