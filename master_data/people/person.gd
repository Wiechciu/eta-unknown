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


@warning_ignore("shadowed_variable")
func with_data(first_name: String, last_name: String, gender: String, email: String, phone_number: String, birthdate: String, experience: Experience, employer: Party, job_position: JobPosition) -> Person:
	self.first_name = first_name
	self.last_name = last_name
	self.gender = gender
	self.email = email
	self.phone_number = phone_number
	self.birthdate = birthdate
	self.experience = experience
	self.employer = employer
	self.job_position = job_position
	
	return self
