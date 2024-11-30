class_name Customer
extends Party


var requests_for_quotation: Array[RequestForQuotation]
var shipments: Array[Shipment]


func create_new_request_for_quotation() -> void:
	var new_request: RequestForQuotation = RequestForQuotation.new().with_data(self)
	if new_request != null:
		requests_for_quotation.append(new_request)


func create_new_shipment() -> void:
	var new_shipment: Shipment = Shipment.new().with_data(self, null)
	if new_shipment != null:
		shipments.append(new_shipment)
