class_name Person
extends Resource


enum Experience {
	NOVICE,
	SPECIALIST,
	EXPERT,
}


@export_storage var first_name: String
@export_storage var last_name: String
@export_storage var gender: String
@export_storage var email: String
@export_storage var phone_number: String
@export_storage var birthdate: String
@export_storage var experience: Experience
var full_name: String:
	get:
		return first_name + " " + last_name

@export_storage var employer: Party
@export_storage var job_position: JobPosition


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
