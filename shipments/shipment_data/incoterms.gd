class_name Incoterms
extends Resource


enum Code {
	EXW,
	FCA,
	CPT,
	CIP,
	DAP,
	DPU,
	DDP,
	FAS,
	FOB,
	CFR,
	CIF,
}


var code: Code
var place: String

var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		match code:
			Code.EXW: return "Ex Works"
			Code.FCA: return "Free Carrier"
			Code.CPT: return "Carriage Paid To"
			Code.CIP: return "Carriage and Insurance Paid To"
			Code.DAP: return "Delivered at Place"
			Code.DPU: return "Delivered at Place Unloaded"
			Code.DDP: return "Delivered Duty Paid"
			Code.FAS: return "Free Alongside Ship"
			Code.FOB: return "Free on Board"
			Code.CFR: return "Cost and Freight"
			Code.CIF: return "Cost, Insurance and Freight"
			_: return "%s - unknown incoterm" % code_string
var group: String:
	get:
		return code_string.left(1)
var print_string: String:
	get:
		return code_string + " " + place


func with_data(code_to_assign: Code, place_to_assign: String = "") -> Incoterms:
	self.code = code_to_assign
	self.place = place_to_assign
	return self


func with_data_random(place_to_assign: String = "") -> Incoterms:
	return with_data(get_random_code(), place_to_assign)


func get_random_code() -> Code:
	return Code[Code.keys()[randi() % Code.size()]]
