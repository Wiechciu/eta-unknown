class_name Carrier
extends Supplier


static var all_specific: Array[Carrier]
static var all_specific_dict: Dictionary[String, Carrier]
static var all_specific_with_employees: Array[Carrier]:
	get:
		return all_specific.filter(Party.has_employees)
