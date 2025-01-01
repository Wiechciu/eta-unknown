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
func with_data(id: int, shipment: Shipment, request_for_quotation: RequestForQuotation, quoting_forwarder: Party, number: String, currency: Currency, revenue_charges: Array[Charge], cost_charges: Array[Charge], transit_time: int, status: Status) -> Quotation:
	self.id = id
	self.shipment = shipment
	self.request_for_quotation = request_for_quotation
	self.quoting_forwarder = quoting_forwarder
	self.number = number
	self.currency = currency
	self.revenue_charges = revenue_charges
	self.cost_charges = cost_charges
	self.transit_time = transit_time
	self.status = status
	
	GlobalRefs.quotations.append(self)
	GlobalRefs.quotations_dict[id] = self

	return self


@warning_ignore("shadowed_variable")
func with_data_random(request_for_quotation: RequestForQuotation, quoting_forwarder: Party) -> Quotation:
	id = GlobalRefs.get_quotation_id()
	
	self.request_for_quotation = request_for_quotation
	shipment = request_for_quotation.shipment
	self.quoting_forwarder = quoting_forwarder
	
	number = str(id)
	currency = GlobalRefs.currencies_code_dict.EUR
	var afr_cost: Charge = Charge.new().with_data(Charge.Code.AFR, Charge.Type.COST, randi_range(3, 5) * shipment.cargo_details.total_weight, currency, GlobalRefs.carriers_with_employees.pick_random())
	var afr_revenue: Charge = Charge.new().from_cost_with_margin(afr_cost, randf_range(0, 0.3), 0, request_for_quotation.requestor)
	cost_charges.append(afr_cost)
	revenue_charges.append(afr_revenue)
	
	var pup_cost: Charge = Charge.new().with_data(Charge.Code.PUP, Charge.Type.COST, randi_range(50, 500), currency, GlobalRefs.carriers_with_employees.pick_random())
	var pup_revenue: Charge = Charge.new().from_cost_with_margin(pup_cost, randf_range(0, 0.3), 0, request_for_quotation.requestor)
	cost_charges.append(pup_cost)
	revenue_charges.append(pup_revenue)
	
	var del_cost: Charge = Charge.new().with_data(Charge.Code.DEL, Charge.Type.COST, randi_range(50, 500), currency, GlobalRefs.carriers_with_employees.pick_random())
	var del_revenue: Charge = Charge.new().from_cost_with_margin(del_cost, randf_range(0, 0.3), 0, request_for_quotation.requestor)
	cost_charges.append(del_cost)
	revenue_charges.append(del_revenue)
	
	transit_time = GlobalTimer.ONE_DAY * randi_range(5, 25)
	
	status = Status.CREATED
	
	GlobalRefs.quotations.append(self)
	GlobalRefs.quotations_dict[id] = self
	
	#print("New quotation created, ID: %s." % [id])
	return self


func change_status(new_status: Status) -> void:
	status = new_status
	
	if status == Status.AWARDED:
		shipment.accept(quoting_forwarder)
		shipment.accounting.register_charges_from_quotation(self)


func to_dict() -> Dictionary:
	return {
		"id" = id,
		"shipment_id" = str(shipment.id) if shipment else "",
		"request_for_quotation_id" = str(request_for_quotation.id) if request_for_quotation else "",
		"quoting_forwarder_id" = str(quoting_forwarder.id) if quoting_forwarder else "",
		"number" = number,
		"currency_id" = str(currency.id) if currency else "",
		"revenue_charges" = Charge.array_to_dict(revenue_charges),
		"cost_charges" = Charge.array_to_dict(cost_charges),
		"transit_time" = transit_time,
		"status" = status,
	}


static func from_dict(data: Dictionary) -> Quotation:
	return Quotation.new().with_data(
		data.id,
		null,
		null,
		null,
		data.number,
		GlobalRefs.currencies_dict[data.currency_id as int],
		Charge.array_from_dict(data.revenue_charges),
		Charge.array_from_dict(data.cost_charges),
		data.transit_time,
		data.status,
	)


func assign_references_from_dict(data: Dictionary) -> void:
	self.shipment = GlobalRefs.shipments_dict[data.shipment_id as int]
	self.request_for_quotation = GlobalRefs.requests_for_quotation[data.request_for_quotation_id as int]
	self.quoting_forwarder = GlobalRefs.parties_dict[data.quoting_forwarder_id as int]


static func array_to_dict(data: Array[Quotation]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Quotation in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Quotation]:
	var array: Array[Quotation]
	for item: Dictionary in data:
		array.append(Quotation.from_dict(item))
	return array


static func array_to_dict_id(data: Array[Quotation]) -> Array[int]:
	var array: Array[int]
	for item: Quotation in data:
		array.append(item.id)
	return array


static func array_from_dict_id(data: Array) -> Array[Quotation]:
	var array: Array[Quotation]
	for item: int in data:
		array.append(GlobalRefs.quotations_dict[item])
	return array
