class_name Customer
extends Party


var shipments: Array[Shipment]


func create_new_shipment() -> void:
	var new_shipment: Shipment = Shipment.new().with_data(self, null)
	if new_shipment != null:
		shipments.append(new_shipment)
