class_name HandlingAgent
extends Party


static var all_specific: Array[HandlingAgent]
static var all_specific_dict: Dictionary[String, HandlingAgent]
static var all_specific_with_employees: Array[HandlingAgent]:
	get:
		return all_specific.filter(Party.has_employees)
