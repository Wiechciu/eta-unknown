class_name Human
extends CharacterBody3D


var id: int
var person: Person


func _ready() -> void:
	assign_person()


func assign_person() -> void:
	id = GlobalRefs.get_human_id()
	
	if GlobalRefs.freight_forwarders_with_employees.is_empty():
		await SaveManager.game_loaded
	
	if person == null:
		var company: Party = GlobalRefs.freight_forwarders_with_employees.pick_random() as Party
		person = company.employees.pick_random() as Person
		person.job_position = GlobalRefs.job_positions_dict[0] ## Intern
	
	GlobalRefs.humans.append(self)
	GlobalRefs.humans_dict[id] = self


func to_dict() -> Dictionary:
	return {
		"id" = id,
		"person_id" = person.id if person else "",
		"position_x" = position.x,
		"position_y" = position.y,
		"position_z" = position.z,
		"rotation_x" = rotation.x,
		"rotation_y" = rotation.y,
		"rotation_z" = rotation.z,
	}


func from_dict(data: Dictionary) -> void:
	person = GlobalRefs.people_dict[data["person_id"] as int]
	position = Vector3(data["position_x"], data["position_y"], data["position_z"])
	rotation = Vector3(data["rotation_x"], data["rotation_y"], data["rotation_z"])
	
	GlobalRefs.humans.append(self)
	GlobalRefs.humans_dict[id] = self
