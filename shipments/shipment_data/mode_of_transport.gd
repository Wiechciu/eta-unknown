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


static func create_new(code: Code) -> ModeOfTransport:
	var new := ModeOfTransport.new()
	new.code = code
	return new


static func create_new_with_random_code() -> ModeOfTransport:
	return create_new(get_random_code())


static func get_random_code() -> Code:
	return Code[Code.keys()[randi() % Code.size()]]
