class_name Incoterms
extends Resource


var incoterms_data: IncotermsData
var place: String
var print_string: String:
	get:
		return incoterms_data.code + " " + place


@warning_ignore("shadowed_variable")
static func create_new(code: String, place: String = "") -> Incoterms:
	var new_incoterms: Incoterms = Incoterms.new()
	new_incoterms.incoterms_data = IncotermsData.get_incoterms_by_code(code)
	new_incoterms.place = place
	return new_incoterms


@warning_ignore("shadowed_variable")
static func create_new_with_random_data(place: String = "") -> Incoterms:
	return create_new((GlobalRefs.incoterms.pick_random() as IncotermsData).code, place)
