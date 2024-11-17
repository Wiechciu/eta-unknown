class_name Person
extends Resource


enum Experience {
	NOVICE,
	SPECIALIST,
	EXPERT,
}

static var all: Array[Person]
static var all_dict: Dictionary[String, Person]
static var all_with_employer: Array[Party]:
	get:
		return all.filter(has_employer)


var first_name: String
var last_name: String
var gender: String
var email: String
var phone_number: String
var birthdate: String
var experience: Experience
var full_name: String:
	get:
		return first_name + " " + last_name

var employer: Party
var job_position: JobPosition


static func has_employer(person_to_check: Person) -> bool:
	return person_to_check.employer != null
