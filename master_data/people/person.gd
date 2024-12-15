class_name Person
extends Resource


enum Experience {
	NOVICE,
	SPECIALIST,
	EXPERT,
}

@export_storage var id: int
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
func with_data(id: int, first_name: String, last_name: String, gender: String, email: String, phone_number: String, birthdate: String, experience: Experience, employer: Party, job_position: JobPosition) -> Person:
	self.id = id
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


func to_dict() -> Dictionary:
	return {
		"id" = id,
		"first_name" = first_name,
		"last_name" = last_name,
		"gender" = gender,
		"email" = email,
		"phone_number" = phone_number,
		"birthdate" = birthdate,
		"experience" = experience,
		"employer_id" = employer.id if employer else "",
		"job_position_id" = job_position.id if job_position else "",
	}


static func from_dict(data: Dictionary) -> Person:
	return Person.new().with_data(
		data["id"],
		data["first_name"],
		data["last_name"],
		data["gender"],
		data["email"],
		data["phone_number"],
		data["birthdate"],
		data["experience"],
		GlobalRefs.parties[data["employer_id"]],
		GlobalRefs.job_positions[data["job_position_id"]],
	)


static func array_to_dict(data: Array[Person]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Person in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Person]:
	var array: Array[Person]
	for item: Dictionary in data:
		array.append(Person.from_dict(item))
	return array
