class_name RequestForQuotation
extends Resource


enum AwardCriteria {
	PRICE,
	TIME,
	MIXED,
}


static var last_id: int = 0

var id: int
var shipment: Shipment
var requestor: Customer
var expected_total_cost: float
var deadline_date: int
var deadline_time_event: TimeEvent
var award_criteria: AwardCriteria
var quotations: Array[Quotation]
var awarded_quotation: Quotation
var is_awarded: bool:
	get:
		return awarded_quotation != null


func with_data(customer: Customer) -> RequestForQuotation:
	last_id += 1
	id = last_id

	requestor = customer
	
	var export_chance: float = 0.5
	var is_export: bool = randf() < export_chance
	if is_export:
		shipment = Shipment.new().with_data(customer, null)
	else:
		shipment = Shipment.new().with_data(null, customer)
	
	if shipment == null:
		return null
	
	var expected_rate_per_kg: float = 5 #TODO implement some market rates
	expected_total_cost = shipment.cargo_details.total_weight * expected_rate_per_kg
	var random_day_offset: int = randi_range(1, 3)
	var random_hour: int = randi_range(10, 16)
	deadline_date = GlobalTimer.get_future_date_from_now(random_day_offset, random_hour)
	deadline_time_event = GlobalTimer.create_time_event_from_unix_time(deadline_date, self)
	award_criteria = AwardCriteria.values()[randi() % AwardCriteria.size()]
	
	shipment.accounting.request_for_quotation = self
	GlobalRefs.requests_for_quotation.append(self)
	print("New request for quotation created. RFQ ID: %s. There are %s active rfqs." % [id, GlobalRefs.requests_for_quotation.size()])
	return self


func register_quotation(new_quotation: Quotation) -> void:
	quotations.append(new_quotation)
	print("Quotation ID %s registered for Request ID %s. There are %s quotations registered." % [new_quotation.id, id, quotations.size()])


func finalize() -> void:
	if quotations.is_empty():
		return
	
	match award_criteria:
		AwardCriteria.PRICE:
			quotations.sort_custom(_sort_by_cost_descending)
		AwardCriteria.TIME:
			quotations.sort_custom(_sort_by_transit_time_ascending)
		AwardCriteria.MIXED:
			pass #TODO - check which quotation is highest in both sortings combined
	
	award_quotation(quotations[0])


func award_quotation(quotation_to_award: Quotation) -> void:
	awarded_quotation = quotation_to_award
	shipment.accounting.quotation = awarded_quotation
	for quotation: Quotation in quotations:
		if quotation == awarded_quotation:
			quotation.change_status(Quotation.Status.AWARDED)
		else:
			quotation.change_status(Quotation.Status.LOST)
	print("Awarded Quotation ID %s of Request ID %s to forwarder %s" % [quotation_to_award.id, id, quotation_to_award.quoting_forwarder.name])


func notify(time_event: TimeEvent) -> void:
	if time_event == deadline_time_event:
		finalize()


func _sort_by_cost_descending(a: Quotation, b: Quotation) -> bool:
	if a.total_amount < b.total_amount:
		return true
	return false


func _sort_by_transit_time_ascending(a: Quotation, b: Quotation) -> bool:
	if a.transit_time > b.transit_time:
		return true
	return false
