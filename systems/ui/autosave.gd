class_name AutosaveSettings
extends HBoxContainer


@export var check_box: CheckBox
#@export var line_edit: LineEdit
@export var spin_box: SpinBox
@export var label: Label
var value_bool: bool:
	get: return check_box.button_pressed
	set(value):
		check_box.button_pressed = value
		_on_check_box_pressed()
var value_number: int:
	get: return int(spin_box.value)
	set(value):
		spin_box.value = value
		_on_spin_box_value_changed(value)


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	check_box.pressed.connect(_on_check_box_pressed)
	spin_box.value_changed.connect(_on_spin_box_value_changed)
	#line_edit.text_changed.connect(_on_line_edit_text_changed)


func _on_check_box_pressed() -> void:
	SaveManager.autosave = check_box.button_pressed
	spin_box.visible = check_box.button_pressed
	label.visible = check_box.button_pressed


func _on_spin_box_value_changed(value: float) -> void:
	SaveManager.autosave_interval = int(value)
	update_localization()


func _notification(what: int) -> void:
	if Engine.is_editor_hint():
		return
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		update_localization()


func update_localization() -> void:
	label.text = tr("EVERY_X_DAYS").format({"amount":int(spin_box.value)})


#func _on_line_edit_text_changed(new_text: String) -> void:
	#var converted_to_int: int = int(line_edit.text)
	#line_edit.text = str(converted_to_int)
	#SaveManager.autosave_interval = converted_to_int
