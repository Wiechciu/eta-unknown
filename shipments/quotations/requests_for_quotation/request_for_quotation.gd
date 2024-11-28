class_name RequestForQuotation
extends Resource


var requestor: Customer
var shipment: Shipment
var expected_total_cost: float
var deadline_date: int
var quotations: Array[Quotation]


func with_data(customer: Customer) -> RequestForQuotation:
	self.requestor = customer
	
	var export_chance: float = 0.5
	var is_export: bool = randf() < export_chance
	if is_export:
		self.shipment = Shipment.new().with_data(customer, null)
	else:
		self.shipment = Shipment.new().with_data(null, customer)
	
	if self.shipment == null:
		return null
	
	var expected_rate_per_kg: float = 1000 #TODO implement some market rates
	self.expected_total_cost = self.shipment.cargo_details.total_weight * expected_rate_per_kg
	self.deadline_date = GlobalTimer.get_future_date_from_now(randi_range(1, 5), randi_range(10, 16))
	
	return self


func register_quotation(new_quotation: Quotation) -> void:
	quotations.append(new_quotation)


func award_quotation() -> void:
	pass #TODO
