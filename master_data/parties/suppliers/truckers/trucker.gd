class_name Trucker
extends Supplier


static var all_specific: Array[Trucker]
static var all_specific_dict: Dictionary[String, Trucker]
static var all_specific_with_employees: Array[Trucker]:
	get:
		return all_specific.filter(Party.has_employees)
