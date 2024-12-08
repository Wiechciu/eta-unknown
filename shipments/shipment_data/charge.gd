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
		return tr("CHARGE_" + code_string)
var amount: float
var amount_string: String:
	get: return "%.2f" % amount
var currency: Currency
var party: Party
