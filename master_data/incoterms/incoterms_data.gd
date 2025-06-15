class_name IncotermsData
extends Resource


@export var code: String
@export var name: String
@export var description: String
var group: String:
	get:
		return code.left(1)


@warning_ignore("shadowed_variable")
static func get_incoterms_by_code(code: String) -> IncotermsData:
	for incoterms: IncotermsData in GlobalRefs.incoterms:
		if incoterms.code == code:
			return incoterms
	
	printerr("Could't find event code: " + code)
	return null
