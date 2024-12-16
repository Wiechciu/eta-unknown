class_name SaveListItem
extends PanelContainer


signal pressed_with_data(save_name: String)


@export var label: Label
@export var button: Button
var save_name: String


func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)
	
	button.pressed.connect(_on_button_pressed)


func with_data(save_name: String) -> SaveListItem:
	self.label.text = save_name
	self.save_name = save_name
	
	return self


func _on_button_pressed() -> void:
	pressed_with_data.emit(save_name)
