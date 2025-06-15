class_name DocumentData
extends Resource

@export var code: String
@export var name: String
@export var description: String


@warning_ignore("shadowed_variable")
static func get_document_by_code(code: String) -> DocumentData:
	for document: DocumentData in GlobalRefs.documents:
		if document.code == code:
			return document
	
	printerr("Could't find document code: " + code)
	return null
