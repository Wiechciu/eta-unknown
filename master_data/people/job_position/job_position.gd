class_name JobPosition
extends Resource


@export var id: int
@export var title: String
@export var salary: float


@warning_ignore("shadowed_variable")
static func create_new(id: int, title: String, salary: float) -> JobPosition:
	var new_job_position: JobPosition = JobPosition.new()
	new_job_position.id = id
	new_job_position.title = title
	new_job_position.salary = salary
	
	GlobalRefs.job_positions.append(new_job_position)
	
	return new_job_position


#func to_dict() -> Dictionary:
	#return {
		#"id" = id,
		#"title" = title,
		#"salary" = salary,
	#}
#
#
#static func from_dict(data: Dictionary) -> JobPosition:
	#return JobPosition.new().with_data(
		#data["id"],
		#data["title"],
		#data["salary"],
	#)
#
#
#static func array_to_dict(data: Array[JobPosition]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: JobPosition in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[JobPosition]:
	#var array: Array[JobPosition]
	#for item: Dictionary in data:
		#array.append(JobPosition.from_dict(item))
	#return array
