class_name RequestForQuotation
extends Resource


enum AwardCriteria {
	PRICE,
	TIME,
	MIXED,
}


var id: int
var shipment: Shipment
var requestor: Customer
var expected_total_cost: float
var expected_transit_time: int
var deadline_date: int
var award_criteria: AwardCriteria
var quotations: Array[Quotation]
var awarded_quotation: Quotation
var is_awarded: bool:
	get:
		return awarded_quotation != null
var deadline_time_event: TimeEvent


@warning_ignore("shadowed_variable")
func with_data(id: int, shipment: Shipment, requestor: Customer, expected_total_cost: float, expected_transit_time: int, deadline_date: int, award_criteria: AwardCriteria, quotations: Array[Quotation], awarded_quotation: Quotation, ) -> RequestForQuotation:
	self.id = id
	self.shipment = shipment
	self.requestor = requestor
	self.expected_total_cost = expected_total_cost
	self.expected_transit_time = expected_transit_time
	self.deadline_date = deadline_date
	self.award_criteria = award_criteria
	self.quotations = quotations
	self.awarded_quotation = awarded_quotation
	
	self.deadline_time_event = GlobalTimer.create_time_event_from_unix_time(deadline_date, self)
	
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	GlobalRefs.requests_for_quotation.append(self)
	
	return self


func with_data_random(customer: Customer) -> RequestForQuotation:
	@warning_ignore("unsafe_method_access")
	id = GlobalRefs.get_request_for_quotation_id()
	
	requestor = customer
	
	var export_chance: float = 0.5
	var is_export: bool = randf() < export_chance
	if is_export:
		shipment = Shipment.new().with_data_random(customer, null)
	else:
		shipment = Shipment.new().with_data_random(null, customer)
	
	if shipment == null:
		return null
	
	@warning_ignore("unsafe_property_access")
	var expected_rate_per_kg: float = GlobalMarket.market_rates_dict[shipment.origin.country.code + shipment.destination.country.code]
	var margin_allowance: float = randf_range(1.05, 1.5)
	expected_total_cost = shipment.cargo_details.total_weight * expected_rate_per_kg * margin_allowance
	var random_day_offset: int = randi_range(1, 3)
	var random_hour: int = randi_range(10, 16)
	@warning_ignore("unsafe_method_access")
	deadline_date = GlobalTimer.get_future_date_from_now(random_day_offset, random_hour)
	@warning_ignore("unsafe_method_access")
	deadline_time_event = GlobalTimer.create_time_event_from_unix_time(deadline_date, self)
	award_criteria = AwardCriteria.values()[randi() % AwardCriteria.size()]
	
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
	GlobalRefs.requests_for_quotation.append(self)
	@warning_ignore("unsafe_property_access", "unsafe_method_access")
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
			if quotations[0].revenue_charges_sum > expected_total_cost:
				award_quotation(null)
				return
		AwardCriteria.TIME:
			quotations.sort_custom(_sort_by_transit_time_ascending)
			if quotations[0].transit_time > expected_transit_time:
				award_quotation(null)
				return
		AwardCriteria.MIXED:
			pass #TODO - check which quotation is highest in both sortings combined
	
	award_quotation(quotations[0])


func award_quotation(quotation_to_award: Quotation) -> void:
	if quotation_to_award == null:
		print("None of the quotations matched the criteria of Request ID %s, no quotation awarded" % id)
		return
	
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
	if a.revenue_charges_sum < b.revenue_charges_sum:
		return true
	return false


func _sort_by_transit_time_ascending(a: Quotation, b: Quotation) -> bool:
	if a.transit_time > b.transit_time:
		return true
	return false


func to_dict() -> Dictionary:
	return {
		"id" = id,
		"shipment_id" = shipment.id if shipment else "",
		"requestor_id" = requestor.id if requestor else "",
		"expected_total_cost" = expected_total_cost,
		"expected_transit_time" = expected_transit_time,
		"deadline_date" = deadline_date,
		"award_criteria" = award_criteria,
		"quotation_ids" = Quotation.array_to_dict_id(quotations),
		"awarded_quotation_id" = awarded_quotation.id if awarded_quotation else "",
	}


static func from_dict(data: Dictionary) -> RequestForQuotation:
	return RequestForQuotation.new().with_data(
		data["id"],
		GlobalRefs.shipments[data["shipment_id"]],
		GlobalRefs.parties[data["requestor_id"]],
		data["expected_total_cost"],
		data["expected_transit_time"],
		data["deadline_date"],
		data["award_criteria"],
		Quotation.array_from_dict_id(data["quotation_ids"]),
		GlobalRefs.quotations[data["awarded_quotation_id"]],
	)


static func array_to_dict(data: Array[RequestForQuotation]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: RequestForQuotation in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[RequestForQuotation]:
	var array: Array[RequestForQuotation]
	for item: Dictionary in data:
		array.append(RequestForQuotation.from_dict(item))
	return array


static func array_to_dict_id(data: Array[RequestForQuotation]) -> Array[int]:
	var array: Array[int]
	for item: RequestForQuotation in data:
		array.append(item.id)
	return array


static func array_from_dict_id(data: Array[int]) -> Array[RequestForQuotation]:
	var array: Array[RequestForQuotation]
	for item: int in data:
		array.append(GlobalRefs.requests_for_quotation[item])
	return array
