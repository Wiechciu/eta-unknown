class_name Customer
extends Party


static var all_specific: Array[Customer]
static var all_specific_dict: Dictionary[String, Customer]
static var all_specific_with_employees: Array[Customer]:
	get:
		return all_specific.filter(Party.has_employees)

var shipments: Array[Shipment]


func create_new_shipment() -> void:
	var new_shipment = Shipment.create_new(self, null)
	if new_shipment != null:
		shipments.append(new_shipment)
