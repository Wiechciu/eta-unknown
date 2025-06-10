class_name Person
extends Resource


enum Experience {
	NOVICE,
	SPECIALIST,
	EXPERT,
}

var id: int
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

var skills: Array[SkillData]

var employer: Party
var job_position: JobPosition


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
	
	GlobalRefs.people.append(self)
	GlobalRefs.people_dict[id] = self
	
	for skill: Skill in GlobalRefs.skills:
		var skill_data: SkillData = SkillData.new()
		skill_data.skill = skill
		skill_data.value = 1.0
		skills.append(skill_data)
	
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
		"employer_id" = str(employer.id) if employer else "",
		"job_position_id" = str(job_position.id) if job_position else "",
	}


static func from_dict(data: Dictionary) -> Person:
	return Person.new().with_data(
		data.id,
		data.first_name,
		data.last_name,
		data.gender,
		data.email,
		data.phone_number,
		data.birthdate,
		data.experience,
		null,
		GlobalRefs.job_positions_dict[data.job_position_id as int],
	)


func assign_references_from_dict(data: Dictionary) -> void:
	self.employer = GlobalRefs.parties_dict[data.employer_id as int]


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


static func array_to_dict_id(data: Array[Person]) -> Array[int]:
	var array: Array[int]
	for item: Person in data:
		array.append(item.id)
	return array


static func array_from_dict_id(data: Array) -> Array[Person]:
	var array: Array[Person]
	for item: int in data:
		array.append(GlobalRefs.people_dict[item])
	return array
