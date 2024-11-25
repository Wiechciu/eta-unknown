class_name ShipmentDocumentation
extends Resource


signal documentation_updated


var shipment: Shipment
var documents: Array[Document]
#var commercial_documents: Array[Document] #TODO
#var transport_documents: Array[Document] #TODO
#var customs_documents: Array[Document] #TODO
#var accounting_documents: Array[Document] #TODO


func with_data(parent_shipment: Shipment) -> ShipmentDocumentation:
	self.shipment = parent_shipment
	return self


func register_document(document: Document) -> void:
	documents.append(document)
	documents.sort_custom(_sort_ascending)
	documentation_updated.emit()


func create_new_document(code: Document.Code, issued_time: int, number: int) -> Document:
	var new_document: Document = Document.new().with_data(code, issued_time, number, shipment)
	register_document(new_document)
	return new_document


static func _sort_ascending(a: Document, b: Document) -> bool:
	if a.issued_time < b.issued_time:
		return true
	return false
