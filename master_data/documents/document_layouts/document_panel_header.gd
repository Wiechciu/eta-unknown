class_name DocumentPanelHeader
extends Control


var document_layout_node: DocumentLayout
var is_moving: bool
@export var icon_rect: TextureRect
@export var title_label: Label


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	#gui_input.connect(_on_gui_input)
	document_layout_node = UtilityTools.get_parent_of_type(self, DocumentLayout) as DocumentLayout
	if document_layout_node.document == null:
		await document_layout_node.initialized
	
	#icon_rect.texture = os_app.os_app_icon
	if document_layout_node.custom_title != "":
		title_label.text = document_layout_node.custom_title
	else:
		title_label.text = "%s (%s)" % [document_layout_node.document.document_data.name, document_layout_node.document.document_data.code]


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).pressed:
			document_layout_node.move_to_front()
			is_moving = true
		else:
			is_moving = false
	elif event is InputEventMouseMotion and is_moving:
		document_layout_node.global_position = document_layout_node.global_position + (event as InputEventMouseMotion).relative


func _on_close_button_pressed() -> void:
	document_layout_node.closed.emit()
