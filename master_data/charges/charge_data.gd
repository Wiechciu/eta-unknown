class_name ChargeData
extends Resource


@export var code: String
@export var name: String
@export var description: String


@warning_ignore("shadowed_variable")
static func get_charge_by_code(code: String) -> ChargeData:
	for charge: ChargeData in GlobalRefs.charges:
		if charge.code == code:
			return charge
	
	printerr("Could't find charge code: " + code)
	return null
