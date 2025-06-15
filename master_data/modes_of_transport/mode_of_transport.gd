class_name ModeOfTransport
extends Resource


@export var code: String
@export var name: String
@export var description: String


@warning_ignore("shadowed_variable")
static func get_mode_of_transport_by_code(code: String) -> ModeOfTransport:
	for mode_of_transport: ModeOfTransport in GlobalRefs.modes_of_transport:
		if mode_of_transport.code == code:
			return mode_of_transport
	
	printerr("Could't find mode of transport code: " + code)
	return null
