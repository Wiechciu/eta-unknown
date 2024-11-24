class_name ShipmentDocumentation
extends Resource


var shipment: Shipment
var commercial_documents: Array[Document] #TODO
var transport_documents: Array[Document] #TODO
var customs_documents: Array[Document] #TODO
var accounting_documents: Array[Document] #TODO


static func create_new(parent_shipment: Shipment) -> ShipmentDocumentation:
	var new_documentation := ShipmentDocumentation.new()
	new_documentation.shipment = parent_shipment
	
	return new_documentation
