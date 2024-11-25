class_name Service
extends Resource


enum Code {
	PTP,
	DTD,
	PTD,
	DTP,
}


var code: Code

var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		match code:
			Code.PTP: return "Port to Port"
			Code.DTD: return "Door to Door"
			Code.PTD: return "Port to Door"
			Code.DTP: return "Door to Port"
			_: return "%s - unknown service" % code_string


func with_data(code_to_assign: Code) -> Service:
	self.code = code_to_assign
	return self


func with_data_random() -> Service:
	return self.with_data(get_random_code())


static func get_random_code() -> Code:
	return Code[Code.keys()[randi() % Code.size()]]
