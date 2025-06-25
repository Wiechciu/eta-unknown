class_name Person
extends Resource


const MALE_NAMES: Array[String] = preload("res://master_data/people/person_male_names.json").data
const FEMALE_NAMES: Array[String] = preload("res://master_data/people/person_female_names.json").data
const SURNAMES: Array[String] = preload("res://master_data/people/person_surnames.json").data


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
var states: Array[State]
var skills: Array[Skill]

var employer: Party
var job_position: JobPosition
var supervisor: Person
var subordinates: Array[Person]


static func create_new() -> Person:
	var random_gender: Gender = GlobalRefs.genders.pick_random()
	var random_first_name: String
	if random_gender.gender_name == "male":
		random_first_name = MALE_NAMES.pick_random()
	elif random_gender.gender_name == "female":
		random_first_name = FEMALE_NAMES.pick_random()
	var random_last_name: String = SURNAMES.pick_random()
	
	var new_person: Person = Person.new()
	new_person.id = GlobalRefs.get_person_id()
	new_person.first_name = random_first_name
	new_person.last_name = random_last_name
	new_person.gender = random_gender
	new_person.phone_number = "%s-%s-%s" % [randi_range(500, 999), randi_range(0, 999), randi_range(0, 999)]
	new_person.birthdate = "%04d-%02d-%02d" % [randi_range(1950, 2005), randi_range(1, 12), randi_range(1, 28)] ##TODO: fix so that it can be up to 31 day of the month
	new_person.experience = randi_range(0, Person.Experience.size() - 1) as Person.Experience
	new_person.employer = GlobalRefs.parties.pick_random() as Party
	new_person.job_position = GlobalRefs.job_positions.pick_random() as JobPosition
	new_person.email = "%s.%s@%s" % [random_first_name.to_lower(), random_last_name.to_lower(), new_person.employer.domain if new_person.employer != null else "email.com"]
	
	if not new_person.employer.employees.is_empty():
		new_person.supervisor = new_person.employer.employees.pick_random()
	new_person.employer.employees.append(new_person)
	
	GlobalRefs.people.append(new_person)
	GlobalRefs.people_dict[new_person.id] = new_person
	
	new_person.load_personal_info()
	new_person.load_states()
	new_person.load_skills()
	new_person.set_up_email_scheduling()
	
	return new_person


@warning_ignore("shadowed_variable")
static func get_person_by_email(email: String) -> Person:
	for person: Person in GlobalRefs.people:
		if person.email == email:
			return person
	
	printerr("Could't find person email: " + email)
	return null


#@warning_ignore("shadowed_variable")
#func with_data(id: int, first_name: String, last_name: String, gender: Gender, email: String, phone_number: String, birthdate: String, experience: Experience, employer: Party, job_position: JobPosition) -> Person:
	#self.id = id
	#self.first_name = first_name
	#self.last_name = last_name
	#self.gender = gender
	#self.email = email
	#self.phone_number = phone_number
	#self.birthdate = birthdate
	#self.experience = experience
	#self.employer = employer
	#self.job_position = job_position
	#
	#GlobalRefs.people.append(self)
	#GlobalRefs.people_dict[id] = self
	#
	#load_personal_info()
	#load_states()
	#load_skills()
	#
	#return self


func load_personal_info() -> void:
	for personal_info_data: PersonalInfoData in GlobalRefs.personal_info_data:
		var personal_info: PersonalInfo = PersonalInfo.create(personal_info_data, self)
		personal_infos.append(personal_info)


func load_states() -> void:
	for state_data: StateDataNew in GlobalRefs.states:
		var state: State = State.new()
		state.state_data = state_data
		state.value = state_data.initial_value
		state.initialize()
		states.append(state)


func load_skills() -> void:
	for skill_data: SkillData in GlobalRefs.skills:
		var new_skill: Skill = Skill.new()
		new_skill.skill_data = skill_data
		new_skill.value = float(randi_range(0, int(skill_data.max_value)))
		skills.append(new_skill)


func set_up_email_scheduling() -> void:
	if employer.type != Party.Type.CUSTOMER:
		return
	
	if GameManager.player == null:
		await GameManager.player_assigned
	
	if GameManager.player.person == self:
		return
	
	GlobalTimer.shift_started.connect(_on_shift_started)
	EmailServer.email_registered.connect(_on_email_registered)


func _on_email_registered(registered_email: Email) -> void:
	if registered_email.to == self:
		GlobalTimer.create_time_event_from_unix_time(GlobalTimer.now + GlobalTimer.ONE_MINUTE * randi_range(2, 10), self, registered_email)


func _on_shift_started() -> void:
	var chance_for_email: float = 0.3
	if randf() < chance_for_email:
		GlobalTimer.create_time_event_from_unix_time(GlobalTimer.now + GlobalTimer.ONE_MINUTE * randi_range(10, 8 * 60), self)


func notify(time_event: TimeEvent) -> void:
	if time_event.args.is_empty():
		create_email(time_event.time)
		return
	
	var original_email: Email = time_event.args.front() as Email
	if original_email != null:
		if original_email.from == self:
			create_reminder(time_event.time, original_email)
		elif original_email.to == self:
			create_response(time_event.time, original_email)
		return


func create_email(time: int) -> void:
	var shipment: Shipment = Shipment.create_new_with_random_data(employer, GlobalRefs.customers_with_employees.pick_random())
	if shipment == null:
		return
	
	var attachments: Array[Document] = []
	var subject: String
	var chance_for_rfq: float = 0.5
	if randf() < chance_for_rfq:
		subject = EmailServer.EMAIL_SUBJECTS_RFQ.pick_random()
		var document: Document = Document.create_new("RFQ", GlobalTimer.now, randi_range(1000000,9999999), shipment)
		attachments.append(document)
	else:
		subject = EmailServer.EMAIL_SUBJECTS_SPO.pick_random()
		var document: Document = Document.create_new("SPO", GlobalTimer.now, randi_range(1000000,9999999), shipment)
		attachments.append(document)
	
	var new_email: Email = Email.create_new(
		self,
		GameManager.player.person,
		subject,
		"As attached" + EmailServer.get_footer(self),
		time,
		attachments,
		null
	)
	
	EmailServer.register_email(new_email)
	GlobalTimer.create_time_event_from_unix_time(time + randi_range(GlobalTimer.ONE_HOUR * 2, GlobalTimer.ONE_HOUR * 4), self, new_email)


func create_reminder(time: int, original_email: Email) -> void:
	for response: Email in original_email.responses:
		var response_exists: bool = response.from == original_email.to
		if response_exists:
			return
	
	var message: String = "Hello," + \
		EmailServer.LINE_BREAK + "Kind reminder on the matter below." + \
		EmailServer.get_footer(self)
	
	var attachments: Array[Document] = original_email.attachments
	var new_email: Email = Email.create_new(
		self,
		original_email.to,
		EmailServer.REPLY_SUBJECT_PREFIX + original_email.subject + " | reminder",
		message,
		time,
		attachments,
		original_email
	)
	
	EmailServer.register_email(new_email)


func create_response(time: int, original_email: Email) -> void:
	var subject: String = EmailServer.REPLY_SUBJECT_PREFIX + original_email.subject
	var message: String = "Hello," \
		+ EmailServer.LINE_BREAK + "Well noted, thank you!" \
		+ EmailServer.get_footer(self)
	
	var attachments: Array[Document] = []
	var new_email: Email = Email.create_new(
		self,
		original_email.from,
		subject,
		message,
		time,
		attachments,
		original_email
	)
	
	EmailServer.register_email(new_email)


#func to_dict() -> Dictionary:
	#return {
		#"id" = id,
		#"first_name" = first_name,
		#"last_name" = last_name,
		#"gender" = gender,
		#"email" = email,
		#"phone_number" = phone_number,
		#"birthdate" = birthdate,
		#"experience" = experience,
		#"employer_id" = str(employer.id) if employer else "",
		#"job_position_id" = str(job_position.id) if job_position else "",
	#}
#
#
#static func from_dict(data: Dictionary) -> Person:
	#return Person.new().with_data(
		#data.id,
		#data.first_name,
		#data.last_name,
		#data.gender,
		#data.email,
		#data.phone_number,
		#data.birthdate,
		#data.experience,
		#null,
		#GlobalRefs.job_positions[data.job_position_id as int],
	#)
#
#
#func assign_references_from_dict(data: Dictionary) -> void:
	#self.employer = GlobalRefs.parties_dict[data.employer_id as int]
#
#
#static func array_to_dict(data: Array[Person]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: Person in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[Person]:
	#var array: Array[Person]
	#for item: Dictionary in data:
		#array.append(Person.from_dict(item))
	#return array
#
#
#static func array_to_dict_id(data: Array[Person]) -> Array[int]:
	#var array: Array[int]
	#for item: Person in data:
		#array.append(item.id)
	#return array
#
#
#static func array_from_dict_id(data: Array) -> Array[Person]:
	#var array: Array[Person]
	#for item: int in data:
		#array.append(GlobalRefs.people_dict[item])
	#return array
