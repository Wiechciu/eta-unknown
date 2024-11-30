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
var request_for_quotation: RequestForQuotation
var quoting_forwarder: FreightForwarder
var number: String
var currency: Currency
var charges: Array[ChargeRevenue]
var total_amount: float:
	get:
		var total: float = 0
		for charge: ChargeRevenue in charges:
			total += charge.amount
		return total
var transit_time: int
var status: Status


func with_data(request_for_quotation_to_apply: RequestForQuotation, quoting_forwarder_to_apply: FreightForwarder) -> Quotation:
	last_id += 1
	id = last_id
	
	request_for_quotation = request_for_quotation_to_apply
	quoting_forwarder = quoting_forwarder_to_apply
	
	number = str(id)
	currency = GlobalRefs.currencies_dict["EUR"]
	for n: int in randi_range(1, 5):
		var new_charge: ChargeRevenue = ChargeRevenue.new().with_data(Charge.Code.AFR, randi_range(100, 1000), currency, request_for_quotation.requestor)
		charges.append(new_charge)
	
	transit_time = GlobalTimer.ONE_DAY * randi_range(5, 25)
	
	status = Status.CREATED
	print("New quotation created, ID: %s." % [id])
	return self


func change_status(new_status: Status) -> void:
	status = new_status
	
	if status == Status.AWARDED:
		request_for_quotation.shipment.accept(quoting_forwarder)
