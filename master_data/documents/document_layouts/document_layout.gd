class_name DocumentLayout
extends Control


signal initialized

@warning_ignore("unused_signal") # Called from the DocumentPanelHeader
signal closed


@export var document: Document
var custom_title: String


@warning_ignore("shadowed_variable")
func initialize(document: Document, custom_title: String = "") -> void:
	self.document = document
	self.custom_title = custom_title
	initialized.emit()
