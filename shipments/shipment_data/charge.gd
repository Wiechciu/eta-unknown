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


var code: Code
var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		match code:
			Code.AFR: return "Airfreight"
			Code.SFR: return "Seafreight"
			Code.PUP: return "Pickup"
			Code.DEL: return "Delivery"
			Code.CSE: return "Export customs clearance"
			Code.CSI: return "Import customs clearance"
			Code.HDE: return "Export handling"
			Code.HDI: return "Import handling"
			_: return "%s - unknown charge" % code_string
var amount: float
var amount_string: String:
	get: return "%.2f" % amount
var currency: Currency
var party: Party
