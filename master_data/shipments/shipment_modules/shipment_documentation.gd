class_name ShipmentDocumentation
extends Resource


signal documentation_updated


var shipment: Shipment
var documents: Array[Document]
#var commercial_documents: Array[Document] #TODO
#var transport_documents: Array[Document] #TODO
#var customs_documents: Array[Document] #TODO
#var accounting_documents: Array[Document] #TODO


@warning_ignore("shadowed_variable")
static func create_new(documents: Array[Document]) -> ShipmentDocumentation:
	var new_shipment_documentation: ShipmentDocumentation = ShipmentDocumentation.new()
	new_shipment_documentation.register_documents(documents)
	
	return new_shipment_documentation


@warning_ignore("shadowed_variable")
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


func create_new_document(code: String, issued_time: int, number: int) -> Document:
	var new_document: Document = Document.create_new(code, issued_time, number, shipment)
	register_document(new_document)
	return new_document


func create_new_document_now(code: String, number: int) -> Document:
	return create_new_document(code, GlobalTimer.now, number)


func _sort_ascending(a: Document, b: Document) -> bool:
	if a.issued_time < b.issued_time:
		return true
	return false
