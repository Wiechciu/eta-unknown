class_name ModeOfTransport
extends Resource


enum Code {
	AIR,
	SEA,
	#LAND,
	#RAIL,
}


var code: Code

var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		match code:
			Code.AIR: return "MOT_AIRFREIGHT"
			Code.SEA: return "MOT_SEAFREIGHT"
			#Code.LAND: return "MOT_LANDFREIGHT"
			#Code.RAIL: return "MOT_RAILFREIGHT"
			_: return "%s - unknown mode of transport" % code_string


@warning_ignore("shadowed_variable")
func with_data(code: Code) -> ModeOfTransport:
	self.code = code
	return self


func with_data_random() -> ModeOfTransport:
	return self.with_data(get_random_code())


func get_random_code() -> Code:
	return Code[Code.keys()[randi() % Code.size()]]
