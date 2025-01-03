extends Button


@export var control_to_hide: Control
@export var control_to_show: Control


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)


func _on_pressed() -> void:
	control_to_hide.hide()
	control_to_show.show()
