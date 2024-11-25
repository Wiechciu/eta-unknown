extends Node


var mutex: Mutex
var thread: Thread
var player: Person


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)
	
	if not JsonLoader.is_node_ready():
		await JsonLoader.ready
	
	GlobalTimer.new_day_started.connect(_initiate_thread)
	
	load_player()


func load_player() -> void:
	var player_company: FreightForwarder = FreightForwarder.all_specific_with_employees.pick_random()
	player = player_company.employees.pick_random()
	player.job_position = JobPosition.all_dict["Intern"]
	print("loaded player: " + player.full_name + ", working at: " + player.employer.name + ", as: " + player.job_position.title)


func create_new_shipments() -> void:
	for customer: Customer in Customer.all_specific_with_employees:
		var chance_to_create: float = 0.01
		if randf() > chance_to_create:
			continue
		
		for i: int in randi_range(0, 5):
			mutex.lock()
			customer.create_new_shipment()
			mutex.unlock()


func _initiate_thread() -> void:
	if thread != null:
		thread.wait_to_finish()
	mutex = Mutex.new()
	thread = Thread.new()
	thread.start(create_new_shipments)


# Thread must be disposed (or "joined"), for portability.
func _exit_tree() -> void:
	thread.wait_to_finish()
