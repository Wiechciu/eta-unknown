class_name Quotation
extends Resource


enum Status {
	CREATED,
	SUBMITTED,
	AWARDED,
	LOST,
}


static var last_id: int = 0

var id: int
var shipment: Shipment
var request_for_quotation: RequestForQuotation
var quoting_forwarder: FreightForwarder
var number: String
var currency: Currency
var revenue_charges: Array[ChargeRevenue]
var revenue_charges_sum: float:
	get:
		var sum: float
		for charge: ChargeRevenue in revenue_charges:
			sum += charge.amount
		return sum
var cost_charges: Array[ChargeCost]
var cost_charges_sum: float:
	get:
		var sum: float
		for charge: ChargeCost in cost_charges:
			sum += charge.amount
		return sum
var transit_time: int
var status: Status


func with_data(request_for_quotation_to_apply: RequestForQuotation, quoting_forwarder_to_apply: FreightForwarder) -> Quotation:
	last_id += 1
	id = last_id
	
	request_for_quotation = request_for_quotation_to_apply
	shipment = request_for_quotation.shipment
	quoting_forwarder = quoting_forwarder_to_apply
	
	number = str(id)
	currency = GlobalRefs.currencies_dict["EUR"]
	var afr_cost: ChargeCost = ChargeCost.new().with_data(Charge.Code.AFR, randi_range(3, 5) * shipment.cargo_details.total_weight, currency, GlobalRefs.carriers_with_employees.pick_random())
	var afr_revenue: ChargeRevenue = ChargeRevenue.new().from_cost_with_margin(afr_cost, randf_range(0, 0.3), 0, request_for_quotation.requestor)
	cost_charges.append(afr_cost)
	revenue_charges.append(afr_revenue)
	
	var pup_cost: ChargeCost = ChargeCost.new().with_data(Charge.Code.PUP, randi_range(50, 500), currency, GlobalRefs.carriers_with_employees.pick_random())
	var pup_revenue: ChargeRevenue = ChargeRevenue.new().from_cost_with_margin(pup_cost, randf_range(0, 0.3), 0, request_for_quotation.requestor)
	cost_charges.append(pup_cost)
	revenue_charges.append(pup_revenue)

	var del_cost: ChargeCost = ChargeCost.new().with_data(Charge.Code.DEL, randi_range(50, 500), currency, GlobalRefs.carriers_with_employees.pick_random())
	var del_revenue: ChargeRevenue = ChargeRevenue.new().from_cost_with_margin(del_cost, randf_range(0, 0.3), 0, request_for_quotation.requestor)
	cost_charges.append(del_cost)
	revenue_charges.append(del_revenue)
	
	transit_time = GlobalTimer.ONE_DAY * randi_range(5, 25)
	
	status = Status.CREATED
	print("New quotation created, ID: %s." % [id])
	return self


func change_status(new_status: Status) -> void:
	status = new_status
	
	if status == Status.AWARDED:
		shipment.accept(quoting_forwarder)
		shipment.accounting.register_charges_from_quotation(self)
