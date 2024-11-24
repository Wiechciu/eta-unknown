class_name RequestForQuotation
extends Resource


static var all: Array[RequestForQuotation]

var requestor: Customer
var shipment: Shipment
var expected_total_cost: float
var deadline_date: int
var quotations: Array[Quotation]


static func create_new(customer: Customer) -> RequestForQuotation:
	var new_request := RequestForQuotation.new()
	all.append(new_request)
	
	new_request.requestor = customer
	
	var export_chance: float = 0.5
	var is_export: bool = randf() < export_chance
	if is_export:
		new_request.shipment = Shipment.create_new(customer, null)
	else:
		new_request.shipment = Shipment.create_new(null, customer)
	
	if new_request.shipment == null:
		return null
	
	var expected_rate_per_kg := 1000 #TODO implement some market rates
	new_request.expected_total_cost = new_request.shipment.cargo_details.total_weight * expected_rate_per_kg
	new_request.deadline_date = GlobalTimer.get_future_date_from_now(randi_range(1, 5), randi_range(10, 16))
	
	return new_request


func register_quotation(new_quotation: Quotation) -> void:
	quotations.append(new_quotation)


func award_quotation() -> void:
	pass #TODO
