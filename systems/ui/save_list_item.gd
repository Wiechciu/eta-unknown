class_name SaveListItem
extends PanelContainer


signal pressed_with_data(save_file_metadata: SaveManager.SaveFileMetadata)


@export var save_file_name: Label
@export var timestamp: Label
@export var game_version: Label
@export var button: Button
var save_file_metadata: SaveManager.SaveFileMetadata


func _ready() -> void:
	GlobalDebugger.assert_all_exported_properties(self)
	
	button.pressed.connect(_on_button_pressed)


@warning_ignore("shadowed_variable")
func with_data(save_file_metadata: SaveManager.SaveFileMetadata) -> SaveListItem:
	self.save_file_name.text = save_file_metadata.save_file_name
	self.timestamp.text = save_file_metadata.timestamp
	
	var version: String = save_file_metadata.game_version
	if SaveManager.is_version_matched(version):
		self.game_version.add_theme_color_override("font_color", Color.DARK_GREEN)
	else:
		self.game_version.add_theme_color_override("font_color", Color.DARK_RED)
	self.game_version.text = "v%s" % version
	
	self.save_file_metadata = save_file_metadata
	
	return self


func _on_button_pressed() -> void:
	pressed_with_data.emit(save_file_metadata)
