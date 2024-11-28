class_name Person
extends Resource


enum Experience {
	NOVICE,
	SPECIALIST,
	EXPERT,
}


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
