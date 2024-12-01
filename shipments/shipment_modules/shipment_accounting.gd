class_name ShipmentAccounting
extends Resource


signal charges_updated


var shipment: Shipment
var request_for_quotation: RequestForQuotation
var quotation: Quotation
var charges: Array[Charge]
var revenue_charges: Array[ChargeRevenue]
var revenue_charges_as_charges: Array[Charge]:
	get:
		var new_list: Array[Charge]
		new_list.assign(revenue_charges)
		return new_list
#FIXME - there can be different currencies, need to calculate with exchange rates
var revenue_charges_sum: float:
	get:
		var sum: float
		for charge: ChargeRevenue in revenue_charges:
			sum += charge.amount
		return sum
var revenue_charges_sum_string: String:
		get: return "%.2f" % revenue_charges_sum
var cost_charges: Array[ChargeCost]
var cost_charges_as_charges: Array[Charge]:
	get:
		var new_list: Array[Charge]
		new_list.assign(cost_charges)
		return new_list
#FIXME - there can be different currencies, need to calculate with exchange rates
var cost_charges_sum: float:
	get:
		var sum: float
		for charge: ChargeCost in cost_charges:
			sum += charge.amount
		return sum
var cost_charges_sum_string: String:
		get: return "%.2f" % cost_charges_sum
var gross_profit: float:
	get: return revenue_charges_sum - cost_charges_sum
var gross_profit_string: String:
		get: return "%.2f" % gross_profit
var margin: float:
	get:
		if revenue_charges_sum == 0:
			return 0
		else:
			return 100 * gross_profit / revenue_charges_sum
var margin_string: String:
		get: return "%.2f%%" % margin


func with_data(parent_shipment: Shipment) -> ShipmentAccounting:
	self.shipment = parent_shipment
	return self


func register_charge(charge: Charge) -> void:
	charges.append(charge)
	if charge is ChargeRevenue:
		revenue_charges.append(charge)
	elif charge is ChargeCost:
		cost_charges.append(charge)
	
	charges_updated.emit()


func register_charges_from_quotation(quotation_to_register: Quotation) -> void:
	for charge_cost: ChargeCost in quotation_to_register.cost_charges:
		register_charge(charge_cost)
	for charge_revenue: ChargeRevenue in quotation_to_register.revenue_charges:
		register_charge(charge_revenue)


func remove_charge(charge: Charge) -> void:
	charges.erase(charge)
	if charge is ChargeRevenue:
		revenue_charges.erase(charge)
	elif charge is ChargeCost:
		cost_charges.erase(charge)
	charges_updated.emit()


func create_new_revenue_charge(code: Charge.Code, amount: float, currency: Currency, party: Party) -> ChargeRevenue:
	var new_charge: ChargeRevenue = ChargeRevenue.new().with_data(code, amount, currency, party)
	register_charge(new_charge)
	return new_charge


func create_new_cost_charge(code: Charge.Code, amount: float, currency: Currency, party: Party) -> ChargeCost:
	var new_charge: ChargeCost = ChargeCost.new().with_data(code, amount, currency, party)
	register_charge(new_charge)
	return new_charge


func get_all_charges_of_type(code: Charge.Code) -> Array[Charge]:
	return charges.filter(func(charge: Charge) -> bool: return charge.code == code)


func get_all_revenue_charges_of_type(code: Charge.Code) -> Array[ChargeRevenue]:
	return revenue_charges.filter(func(charge: ChargeRevenue) -> bool: return charge.code == code)


func get_all_cost_charges_of_type(code: Charge.Code) -> Array[ChargeCost]:
	return cost_charges.filter(func(charge: ChargeCost) -> bool: return charge.code == code)
