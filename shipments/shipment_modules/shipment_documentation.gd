class_name ShipmentDocumentation
extends Resource


signal documentation_updated


@export_storage var documents: Array[Document]
#var commercial_documents: Array[Document] #TODO
#var transport_documents: Array[Document] #TODO
#var customs_documents: Array[Document] #TODO
#var accounting_documents: Array[Document] #TODO


func with_data(documents: Array[Document]) -> ShipmentDocumentation:
	for document: Document in documents:
		register_document(document)
	
	return self


func register_documents(documents: Array[Document]) -> void:
	for document: Document in documents:
		register_document(document)


func register_document(document: Document) -> void:
	documents.append(document)
	documents.sort_custom(_sort_ascending)
	documentation_updated.emit()


func remove_document(document: Document) -> void:
	documents.erase(document)
	documentation_updated.emit()


func create_new_document(code: Document.Code, issued_time: int, number: int) -> Document:
	var new_document: Document = Document.new().with_data(code, issued_time, number)
	register_document(new_document)
	return new_document


func create_new_document_now(code: Document.Code, number: int) -> Document:
	@warning_ignore("unsafe_property_access", "unsafe_call_argument")
	return create_new_document(code, GlobalTimer.now, number)


func _sort_ascending(a: Document, b: Document) -> bool:
	if a.issued_time < b.issued_time:
		return true
	return false
