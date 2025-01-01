class_name Charge
extends Resource


enum Code {
	AFR,
	SFR,
	PUP,
	DEL,
	CSE,
	CSI,
	HDE,
	HDI,
}

enum Type {
	COST,
	REVENUE,
}

var code: Code
var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		return "CHARGE_" + code_string
var type: Type
var amount: float
var amount_string: String:
	get: return "%.2f" % amount
var currency: Currency
var party: Party


@warning_ignore("shadowed_variable")
func with_data(code: Charge.Code, type: Type, amount: float, currency: Currency, party: Party) -> Charge:
	self.code = code
	self.type = type
	self.amount = amount
	self.currency = currency
	self.party = party
	
	return self


@warning_ignore("shadowed_variable")
func from_cost_with_margin(charge_cost: Charge, margin_percentage: float, margin_amount: float, party: Party) -> Charge:
	return with_data(charge_cost.code, Type.REVENUE, charge_cost.amount * (1 + margin_percentage) + margin_amount, charge_cost.currency, party)


func to_dict() -> Dictionary:
	return {
		"code" = code,
		"type" = type,
		"amount" = amount,
		"currency" = currency,
		"party_id" = str(party.id) if party else "",
	}


static func from_dict(data: Dictionary) -> Charge:
	return Charge.new().with_data(
		data.code,
		data.type,
		data.amount,
		data.currency,
		GlobalRefs.parties_dict[data.party_id as int],
	)


static func array_to_dict(data: Array[Charge]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Charge in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Charge]:
	var array: Array[Charge]
	for item: Dictionary in data:
		array.append(Charge.from_dict(item))
	return array
