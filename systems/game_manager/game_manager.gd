extends Node


var player: Person


func _ready() -> void:
	Debugger.assert_all_properties(self)
	
	if not JsonLoader.is_node_ready():
		await JsonLoader.ready
	
	load_player()


func load_player() -> void:
	var player_company: FreightForwarder = FreightForwarder.all_specific_with_employees.pick_random()
	player = player_company.employees.pick_random()
	player.job_position = JobPosition.all_dict["Intern"]
	print("loaded player: " + player.full_name + ", working at: " + player.employer.name + ", as: " + player.job_position.title)
