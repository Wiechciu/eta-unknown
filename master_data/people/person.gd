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
var gender: Gender
var email: String
var phone_number: String
var birthdate: String
var experience: Experience
var full_name: String:
	get:
		return first_name + " " + last_name

var personal_infos: Array[PersonalInfo]
var states: Array[StateData]
var skills: Array[SkillData]

var employer: Party
var job_position: JobPosition
var supervisor: Person
var subordinates: Array[Person]


@warning_ignore("shadowed_variable")
func with_data(id: int, first_name: String, last_name: String, gender: Gender, email: String, phone_number: String, birthdate: String, experience: Experience, employer: Party, job_position: JobPosition) -> Person:
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
	
	load_personal_info()
	load_states()
	load_skills()
	
	return self


func load_personal_info() -> void:
	for personal_info_data: PersonalInfoData in GlobalRefs.personal_info_data:
		var personal_info: PersonalInfo = PersonalInfo.new()
		personal_info.personal_info_data = personal_info_data
		#FIXME do values somehow dynamically?
		match personal_info.personal_info_data.name:
			"Name": personal_info.value = full_name
			"Employer": personal_info.value = employer.name if employer else "---"
			"Supervisor": personal_info.value = supervisor.full_name if supervisor else "---"
			"Salary": personal_info.value = str(job_position.salary) if job_position else "---"
		personal_infos.append(personal_info)


func load_states() -> void:
	for state: State in GlobalRefs.states:
		var state_data: StateData = StateData.new()
		state_data.state = state
		state_data.value = state.initial_value
		state_data.initialize()
		states.append(state_data)


func load_skills() -> void:
	for skill: Skill in GlobalRefs.skills:
		var skill_data: SkillData = SkillData.new()
		skill_data.skill = skill
		skill_data.value = float(randi_range(0, skill.max_value))
		skills.append(skill_data)


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
		GlobalRefs.job_positions[data.job_position_id as int],
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
