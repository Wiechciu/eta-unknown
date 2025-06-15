#TODO: Convert to proper Resource
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


@warning_ignore("shadowed_variable")
static func create_new(code: Code) -> Service:
	var new_service: Service = Service.new()
	new_service.code = code
	return new_service


static func create_new_with_random_data() -> Service:
	return create_new(get_random_code())


static func get_random_code() -> Code:
	return Code[Code.keys()[randi() % Code.size()]]
