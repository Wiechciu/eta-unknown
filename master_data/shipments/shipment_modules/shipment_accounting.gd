class_name ShipmentAccounting
extends Resource


signal charges_updated


var quotation: Quotation
var charges: Array[Charge]
var revenue_charges: Array[Charge]
var cost_charges: Array[Charge]

#var revenue_charges_as_charges: Array[Charge]:
	#get:
		#var new_list: Array[Charge]
		#new_list.assign(revenue_charges)
		#return new_list
var revenue_charges_sum: float: #FIXME - there can be different currencies, need to calculate with exchange rates
	get:
		var sum: float = 0.0
		for charge: Charge in revenue_charges:
			sum += charge.amount
		return sum
var revenue_charges_sum_string: String:
		get: return "%.2f" % revenue_charges_sum
#var cost_charges_as_charges: Array[Charge]:
	#get:
		#var new_list: Array[Charge]
		#new_list.assign(cost_charges)
		#return new_list
var cost_charges_sum: float: #FIXME - there can be different currencies, need to calculate with exchange rates
	get:
		var sum: float = 0.0
		for charge: Charge in cost_charges:
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


@warning_ignore("shadowed_variable")
static func create_new(quotation: Quotation, charges: Array[Charge]) -> ShipmentAccounting:
	var new_shipment_accounting: ShipmentAccounting = ShipmentAccounting.new()
	new_shipment_accounting.quotation = quotation
	new_shipment_accounting.register_charges(charges)
	
	return new_shipment_accounting


@warning_ignore("shadowed_variable")
func register_charges(charges: Array[Charge]) -> void:
	for charge: Charge in charges:
		register_charge(charge)


func register_charge(charge: Charge) -> void:
	charges.append(charge)
	if charge.type == Charge.Type.REVENUE:
		revenue_charges.append(charge)
	elif charge.type == Charge.Type.COST:
		cost_charges.append(charge)
	
	charges_updated.emit()


func register_charges_from_quotation(quotation_to_register: Quotation) -> void:
	for charge_cost: Charge in quotation_to_register.cost_charges:
		register_charge(charge_cost)
	for charge_revenue: Charge in quotation_to_register.revenue_charges:
		register_charge(charge_revenue)


func remove_charge(charge: Charge) -> void:
	charges.erase(charge)
	if charge.type == Charge.Type.REVENUE:
		revenue_charges.erase(charge)
	elif charge.type == Charge.Type.COST:
		cost_charges.erase(charge)
	charges_updated.emit()


func create_new_revenue_charge(code: String, amount: float, currency: Currency, party: Party) -> Charge:
	var new_charge: Charge = Charge.create_new(code, Charge.Type.REVENUE, amount, currency, party)
	register_charge(new_charge)
	return new_charge


func create_new_cost_charge(code: String, amount: float, currency: Currency, party: Party) -> Charge:
	var new_charge: Charge = Charge.create_new(code, Charge.Type.COST, amount, currency, party)
	register_charge(new_charge)
	return new_charge


func get_all_charges_of_code(code: String) -> Array[Charge]:
	return charges.filter(func(charge: Charge) -> bool: return charge.charge_data.code == code)


func get_all_revenue_charges_of_code(code: String) -> Array[Charge]:
	return revenue_charges.filter(func(charge: Charge) -> bool: return charge.charge_data.code == code)


func get_all_cost_charges_of_code(code: String) -> Array[Charge]:
	return cost_charges.filter(func(charge: Charge) -> bool: return charge.charge_data.code == code)
