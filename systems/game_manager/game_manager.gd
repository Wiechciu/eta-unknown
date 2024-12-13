extends Node


@export var json_loader: JsonLoader
var mutex: Mutex
var thread: Thread
var player: Player
var player_person: Person
var player_company: FreightForwarder


func _ready() -> void:
	@warning_ignore("unsafe_method_access")
	GlobalDebugger.assert_all_exported_properties(self)
	
	load_player()
	#GlobalTimer.new_day_started.connect(_initiate_thread)
	GlobalTimer.new_day_started.connect(create_new_shipments)


func load_player() -> void:
	player_company = GlobalRefs.freight_forwarders_with_employees.pick_random()
	player_person = player_company.employees.pick_random()
	player_person.job_position = GlobalRefs.job_positions_dict["Intern"]
	print("loaded player: " + player_person.full_name + ", working at: " + player_company.name + ", as: " + player_person.job_position.title)


func create_new_shipments() -> void:
	for customer: Customer in GlobalRefs.customers_with_employees:
		var chance_to_create: float = 0.02
		if randf() > chance_to_create:
			continue
		
		for i: int in randi_range(0, 5):
			if mutex: mutex.lock()
			customer.create_new_request_for_quotation()
			#customer.create_new_shipment()
			if mutex: mutex.unlock()
	
	var counter: int = 0
	var max_to_accept: int = 5
	for shipment: Shipment in GlobalRefs.shipments_not_owned:
		counter += 1
		if counter > max_to_accept:
			break
		shipment.accept(player_company)


func _initiate_thread() -> void:
	if thread != null:
		thread.wait_to_finish()
	mutex = Mutex.new()
	thread = Thread.new()
	thread.start(create_new_shipments)


# Thread must be disposed (or "joined"), for portability.
func _exit_tree() -> void:
	if thread != null:
		thread.wait_to_finish()
