class_name CustomsAgency
extends Party


static var all_specific: Array[CustomsAgency]
static var all_specific_dict: Dictionary[String, CustomsAgency]
static var all_specific_with_employees: Array[CustomsAgency]:
	get:
		return all_specific.filter(Party.has_employees)
