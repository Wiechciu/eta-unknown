class_name PersonalInfo
extends Resource


@export var personal_info_data: PersonalInfoData
@export var value: String
var person: Person


@warning_ignore("shadowed_variable")
static func create(personal_info_data: PersonalInfoData, person: Person) -> PersonalInfo:
	var personal_info: PersonalInfo = PersonalInfo.new()
	personal_info.personal_info_data = personal_info_data
	personal_info.person = person
	personal_info.update_value()
	
	return personal_info


func update_value() -> void:
	#FIXME do values somehow dynamically?
	match personal_info_data.name:
		"Name": value = person.full_name
		"Gender": value = person.gender.gender_name.capitalize()
		"E-mail": value = person.email
		"Phone": value = person.phone_number
		"Birthdate": value = person.birthdate
		"Employer": value = person.employer.name if person.employer else "---"
		"Job Title": value = person.job_position.title if person.job_position else "---"
		"Supervisor": value = person.supervisor.full_name if person.supervisor else "---"
		"Subordinates": value = str(person.subordinates.size())
		"Salary": value = str(person.job_position.salary) if person.job_position else "---"
