class_name ModeOfTransport
extends Resource


enum Code {
	AIR,
	SEA,
	LAND,
	RAIL,
}


var code: Code

var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		match code:
			Code.AIR: return "Airfreight"
			Code.SEA: return "Seafreight"
			Code.LAND: return "Landfreight"
			Code.RAIL: return "Railfreight"
			_: return "%s - unknown mode of transport" % code_string


func with_data(code_to_assign: Code) -> ModeOfTransport:
	self.code = code_to_assign
	return self


func with_data_random() -> ModeOfTransport:
	return self.with_data(get_random_code())


func get_random_code() -> Code:
	return Code[Code.keys()[randi() % Code.size()]]
