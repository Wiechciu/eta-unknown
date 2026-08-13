class_name Quotation
extends Resource


enum Status {
	CREATED,
	SUBMITTED,
	AWARDED,
	LOST,
}


var id: int
var shipment: Shipment
var request_for_quotation: RequestForQuotation
var quoting_forwarder: Party
var number: String
var currency: Currency
var revenue_charges: Array[Charge]
var revenue_charges_sum: float:
	get:
		var sum: float = 0.0
		for charge: Charge in revenue_charges:
			sum += charge.amount
		return sum
var cost_charges: Array[Charge]
var cost_charges_sum: float:
	get:
		var sum: float = 0.0
		for charge: Charge in cost_charges:
			sum += charge.amount
		return sum
var transit_time: int
var status: Status


@warning_ignore("shadowed_variable")
static func create_new(id: int, shipment: Shipment, request_for_quotation: RequestForQuotation, quoting_forwarder: Party, number: String, currency: Currency, revenue_charges: Array[Charge], cost_charges: Array[Charge], transit_time: int, status: Status) -> Quotation:
	var new_quotation: Quotation = Quotation.new()
	new_quotation.id = id
	new_quotation.shipment = shipment
	new_quotation.request_for_quotation = request_for_quotation
	new_quotation.quoting_forwarder = quoting_forwarder
	new_quotation.number = number
	new_quotation.currency = currency
	new_quotation.revenue_charges = revenue_charges
	new_quotation.cost_charges = cost_charges
	new_quotation.transit_time = transit_time
	new_quotation.status = status
	
	GlobalRefs.quotations.append(new_quotation)
	GlobalRefs.quotations_dict[id] = new_quotation

	return new_quotation


@warning_ignore("shadowed_variable")
static func create_new_with_random_data(request_for_quotation: RequestForQuotation, quoting_forwarder: Party) -> Quotation:
	var id: int = GlobalRefs.get_quotation_id()
	
	var currency: Currency = Currency.get_by_code("EUR")
	var cost_charges: Array[Charge]
	var revenue_charges: Array[Charge]
	var afr_cost: Charge = Charge.create_new("AFR", Charge.Type.COST, randi_range(3, 5) * request_for_quotation.shipment.cargo_details.total_weight, currency, GlobalRefs.carriers_with_employees.pick_random())
	var afr_revenue: Charge = Charge.create_new_from_cost_with_margin(afr_cost, randf_range(0, 0.3), 0, request_for_quotation.requestor)
	cost_charges.append(afr_cost)
	revenue_charges.append(afr_revenue)
	
	var pup_cost: Charge = Charge.create_new("PUP", Charge.Type.COST, randi_range(50, 500), currency, GlobalRefs.carriers_with_employees.pick_random())
	var pup_revenue: Charge = Charge.create_new_from_cost_with_margin(pup_cost, randf_range(0, 0.3), 0, request_for_quotation.requestor)
	cost_charges.append(pup_cost)
	revenue_charges.append(pup_revenue)
	
	var del_cost: Charge = Charge.create_new("DEL", Charge.Type.COST, randi_range(50, 500), currency, GlobalRefs.carriers_with_employees.pick_random())
	var del_revenue: Charge = Charge.create_new_from_cost_with_margin(del_cost, randf_range(0, 0.3), 0, request_for_quotation.requestor)
	cost_charges.append(del_cost)
	revenue_charges.append(del_revenue)
	
	var transit_time: int = GlobalTimer.ONE_DAY * randi_range(5, 25)
	
	var status: Status = Status.CREATED
	
	return create_new(
		id,
		request_for_quotation.shipment,
		request_for_quotation,
		quoting_forwarder,
		str(id),
		currency,
		revenue_charges,
		cost_charges,
		transit_time,
		status
	)


func change_status(new_status: Status) -> void:
	status = new_status
	
	if status == Status.AWARDED:
		shipment.accept(quoting_forwarder)
		shipment.accounting.register_charges_from_quotation(self)


#func to_dict() -> Dictionary:
	#return {
		#"id" = id,
		#"shipment_id" = str(shipment.id) if shipment else "",
		#"request_for_quotation_id" = str(request_for_quotation.id) if request_for_quotation else "",
		#"quoting_forwarder_id" = str(quoting_forwarder.id) if quoting_forwarder else "",
		#"number" = number,
		#"currency_id" = str(currency.id) if currency else "",
		#"revenue_charges" = Charge.array_to_dict(revenue_charges),
		#"cost_charges" = Charge.array_to_dict(cost_charges),
		#"transit_time" = transit_time,
		#"status" = status,
	#}
#
#
#static func from_dict(data: Dictionary) -> Quotation:
	#return Quotation.new().with_data(
		#data.id,
		#null,
		#null,
		#null,
		#data.number,
		#GlobalRefs.currencies_dict[data.currency_id as int],
		#Charge.array_from_dict(data.revenue_charges),
		#Charge.array_from_dict(data.cost_charges),
		#data.transit_time,
		#data.status,
	#)
#
#
#func assign_references_from_dict(data: Dictionary) -> void:
	#self.shipment = GlobalRefs.shipments_dict[data.shipment_id as int]
	#self.request_for_quotation = GlobalRefs.requests_for_quotation[data.request_for_quotation_id as int]
	#self.quoting_forwarder = GlobalRefs.parties_dict[data.quoting_forwarder_id as int]
#
#
#static func array_to_dict(data: Array[Quotation]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: Quotation in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[Quotation]:
	#var array: Array[Quotation]
	#for item: Dictionary in data:
		#array.append(Quotation.from_dict(item))
	#return array
#
#
#static func array_to_dict_id(data: Array[Quotation]) -> Array[int]:
	#var array: Array[int]
	#for item: Quotation in data:
		#array.append(item.id)
	#return array
#
#
#static func array_from_dict_id(data: Array) -> Array[Quotation]:
	#var array: Array[Quotation]
	#for item: int in data:
		#array.append(GlobalRefs.quotations_dict[item])
	#return array
