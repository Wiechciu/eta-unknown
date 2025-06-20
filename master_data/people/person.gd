class_name Person
extends Resource


const MALE_NAMES: Array[String] = [
	"Liam", "Noah", "Oliver", "Elijah", "James", "William", "Benjamin", "Lucas", "Henry", "Alexander",
	"Mason", "Michael", "Ethan", "Daniel", "Jacob", "Logan", "Jackson", "Levi", "Sebastian", "Mateo",
	"Jack", "Owen", "Theodore", "Aiden", "Samuel", "Joseph", "John", "David", "Wyatt", "Matthew",
	"Luke", "Asher", "Carter", "Julian", "Grayson", "Leo", "Jayden", "Gabriel", "Isaac", "Lincoln",
	"Anthony", "Hudson", "Dylan", "Ezra", "Thomas", "Charles", "Christopher", "Jaxon", "Maverick", "Josiah",
	"Isaiah", "Andrew", "Elias", "Joshua", "Nathan", "Caleb", "Ryan", "Adrian", "Miles", "Eli",
	"Nolan", "Christian", "Aaron", "Cameron", "Ezekiel", "Colton", "Luca", "Landon", "Hunter", "Jonathan",
	"Santiago", "Axel", "Easton", "Cooper", "Jeremiah", "Angel", "Roman", "Connor", "Jameson", "Robert",
	"Greyson", "Jordan", "Ian", "Carson", "Jaxson", "Leonardo", "Nicholas", "Dominic", "Austin", "Everett",
	"Brooks", "Xavier", "Kai", "Jose", "Parker", "Adam", "Jace", "Wesley", "Kayden", "Silas"
]
const FEMALE_NAMES: Array[String] = [
	"Olivia", "Emma", "Charlotte", "Amelia", "Sophia", "Isabella", "Ava", "Mia", "Evelyn", "Luna",
	"Harper", "Camila", "Gianna", "Elizabeth", "Eleanor", "Ella", "Abigail", "Sofia", "Avery", "Scarlett",
	"Emily", "Aria", "Penelope", "Chloe", "Layla", "Mila", "Nora", "Hazel", "Madison", "Ellie",
	"Lily", "Nova", "Isla", "Grace", "Violet", "Aurora", "Riley", "Zoey", "Willow", "Emilia",
	"Stella", "Zoe", "Victoria", "Hannah", "Addison", "Leah", "Lucy", "Eliana", "Ivy", "Everly",
	"Lillian", "Paisley", "Elena", "Naomi", "Maya", "Natalie", "Kinsley", "Delilah", "Claire", "Audrey",
	"Aaliyah", "Brooklyn", "Bella", "Aurora", "Savannah", "Skylar", "Genesis", "Hailey", "Autumn", "Kennedy",
	"Valentina", "Josephine", "Ariana", "Allison", "Gabriella", "Alice", "Madelyn", "Cora", "Ruby", "Eva",
	"Serenity", "Autumn", "Adeline", "Hailey", "Piper", "Rylee", "Athena", "Clara", "Samantha", "Liliana",
	"Sarah", "Eva", "Quinn", "Sadie", "Caroline", "Allie", "Eliza", "Juliana", "Arya", "Iris"
]
const SURNAMES: Array[String] = [
	"Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor",
	"Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson",
	"Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King",
	"Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter",
	"Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins",
	"Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey",
	"Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez",
	"James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross",
	"Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington",
	"Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes",
	"Myers","Ford","Hamilton","Graham","Sullivan","Wallace","Woods","Cole","West","Jordan",
	"Owens","Reynolds","Fisher","Ellis","Harrison","Gibson","McDonald","Cruz","Marshall","Ortiz",
	"Gomez","Murray","Freeman","Wells","Webb","Simpson","Stevens","Tucker","Porter","Hunter",
	"Hicks","Crawford","Henry","Boyd","Mason","Morales","Kennedy","Warren","Dixon","Ramos",
	"Reyes","Burns","Gordon","Shaw","Holmes","Rice","Robertson","Hunt","Black","Daniels",
	"Palmer","Mills","Nichols","Grant","Knight","Ferguson","Rose","Stone","Hawkins","Dunn",
	"Perkins","Hudson","Spencer","Gardner","Stephens","Payne","Pierce","Berry","Matthews","Arnold",
	"Wagner","Willis","Ray","Watkins","Olson","Carroll","Duncan","Sutton","Barnett","Shields",
	"Benson","Underwood","Fisher","Fowler","Ellington","Hanson","Santos","Miles","Craig","Rodgers",
	"Jefferson","Fields","Stevenson","Jensen","Marquez","Burnett","Romero","Robles","Stein","Nicholson",
	"Sharpe","Walters","Fox","Moss","Moran","Contreras","Farmer","Bryan","Lane","Riley",
	"Armstrong","Walton","Hart","Mendoza","Richards","Rodriguez","Saunders","Cunningham","Powers","Schmidt",
	"Schultz","Barker","Guzman","Fletcher","Weaver","Schneider","Shannon","Matthews","Hansen","Thompson",
	"Hopkins","Lucas","Harper","Andrews","Larson","Fitzgerald","Iverson","Baldwin","Rojas","Dean",
	"Guerra","Watts","McBride","Cain","Austin","Brock","Fernandez","Wheeler","Carlson","May",
	"McKinney","Pena","Stephenson","Christopher","Rahman","Harrell","Abbott","Shepherd","Boyle","Rangel",
	"Pugh","Sierra","Ventura","Hampton","Britt","Larsen","Curtis","Bradley","Fuentes","Johnston",
	"Gaines","Chandler","Hardy","Macias","Day","Brewer","Cannon","Yates","Hodge","Rivas",
	"Chan","Phelps","Madden","Roman","Brady","Osborne","Casey","Snow","Montoya","Francis",
	"Sandoval","Booth","Atkins","Reese","Bullock","Dawson","Roth","Merritt","Webster","Chapman",
	"Vasquez","Sparks","Justice","Harmon","Bates","Clements","Herrera","Robinson","Meyer","Stone",
	"Rosales","Stevens","Morrison","Kirby","Waller","Johns","Briggs","O’Connor","Keith","Hahn",
	"Trujillo","Ball","Davenport","Snyder","Clayton","Walsh","Farrell","Lowell","Sosa","Neal",
	"Bradford","Ashley","Brock","Lloyd","York","Sweet","Huffman","Bauer","Prince","Lucas",
	"Conner","McKenzie","Bedford","Conrad","Moses","Stanton","Bowers","Lucas","Fitzgerald","Wong",
	"Vaughn","Hopkins","Sanders","Elliott","Case","McDonald","Fletcher","Garrett","Abbott","Ross",
	"Keller","Willis","Thornton","Crosby","Mann","Banks","Rice","Lynn","Chapman","Mason",
	"Todd","Blair","Perry","Gross","Marsh","Gillespie","Roman","Peters","Heath","Crawford",
	"Larson","Dickerson","Rutledge","Duke","Moreno","Powell","Gates","Farmer","Whitehead","Flowers",
	"Cobb","Wheeler","Doyle","Watkins","Park","Hanson","Frank","Patrick","Flynn","Church",
	"Welch","Buchanan","Simon","Brock","Munoz","Faulkner","Holman","Underwood","Cortez","Madden",
	"Klein","Pitts","Savage","Gill","Lamb","Benton","McMillan","Hendrix","Morrow","Justice",
	"Steele","Dickson","Hahn","Roach","Riley","Walters","Frost","Lindsey","Cain","Reeves",
	"Dixon","Oneil","Lucero","Morrison","Fleming","Sheppard","Hodge","Holt","Glenn","Sharp",
	"Yang","Carr","Maynard","Nicholson","Hurley","Robinson","Stokes","Church","Farley","Sweeney",
	"Dickson","Travis","Barrera","Miles","Santana","Irwin","Eaton","Houston","Hahn","Boone",
	"Cervantes","Clarke","Cain","White","Bright","Beck","Hopkins","Albert","Maldonado","Scott",
	"Shaffer","Lang","Gilmore","Knox","Franklin","Hurley","Buchanan","Sharp","Poole","Fletcher",
	"Barron","Cohen","Randall","Rodriguez","Tyson","Pruitt","Cain","Slater","Branch","Palacios",
	"Clayton","Fry","Haynes","Roach","Lyons","Nichols","Mercer","Nolan","Chan","Byrd",
	"Marquez","Craig","Donaldson","Potter","Kent","Hodge","Daniel","Graham","Sheppard","Cross",
	"Woodward","Bolton","McKay","York","Cobb","Herman","Mack","Reese","Horton","Mullen",
	"Roach","Bentley","Cortez","Park","Yates","Giles","Maynard","Miles","Donnell","Salinas",
	"York","Goff","Lyons","Davidson","Potts","Flores","Chase","Hardin","Whitaker","Kaufman",
	"Gonzalez","Huffman","Fox","Schultz","Dorsey","Reilly","Duncan","Simon","Collins","Ledbetter",
	"Pace","Redding","Bruce","Fuller","Nixon","Hodge","Fischer","Walton","Hammond","Maynard",
	"Dennis","Wiley","Olsen","Steele","Bishop","Willis","Holder","Beach","Clayton","Shaffer",
	"Clements","Lang","Blackburn","Hartman","Boyle","McDonald","McMillan","Huber","Ware","Giles",
	"Horne","Cabrera","Joyce","Soto","York","Mccormick","Glass","Dillard","Waller","Flynn"
]

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
	
	GlobalTimer.shift_started.connect(create_time_event_for_email)


func create_time_event_for_email() -> void:
	var chance_for_email: float = 0.3
	if randf() < chance_for_email:
		GlobalTimer.create_time_event_from_unix_time(GlobalTimer.now + GlobalTimer.ONE_MINUTE * randi_range(10, 8 * 60), self)


func notify(time_event: TimeEvent) -> void:
	if time_event.args.is_empty():
		create_email(time_event.time)
	elif time_event.args.front() is Email:
		var original_email: Email = time_event.args.front() as Email
		if original_email.communication_chain.is_empty():
			create_reminder(time_event.time, original_email)


func create_email(time: int) -> void:
	var subject: String
	var chance_for_rfq: float = 0.5
	if randf() < chance_for_rfq:
		subject = EmailServer.EMAIL_SUBJECTS_RFQ.pick_random()
	else:
		subject = EmailServer.EMAIL_SUBJECTS_SPO.pick_random()

	var new_email: Email = Email.create_new(
		self,
		GameManager.player.person,
		subject,
		"As attached" + EmailServer.get_footer(self),
		time,
		[],
		null
	)
	
	EmailServer.register_email(new_email)
	GlobalTimer.create_time_event_from_unix_time(time + randi_range(GlobalTimer.ONE_HOUR * 2, GlobalTimer.ONE_HOUR * 4), self, new_email)


func create_reminder(time: int, original_email: Email) -> void:
	for response: Email in original_email.responses:
		if response.from == original_email.to:
			return
	
	var new_email: Email = Email.create_new(
		self,
		original_email.to,
		EmailServer.REPLY_SUBJECT_PREFIX + original_email.subject + " | reminder",
		EmailServer.add_message_and_footer_to_beginning("Hello,\nKind reminder on the matter below.", original_email.body, self),
		time,
		[],
		original_email
	)
	
	EmailServer.register_email(new_email)
	GlobalTimer.create_time_event_from_unix_time(time + randi_range(GlobalTimer.ONE_HOUR * 2, GlobalTimer.ONE_HOUR * 4), self, new_email)



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
