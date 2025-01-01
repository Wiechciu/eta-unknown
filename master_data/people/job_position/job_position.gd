class_name JobPosition
extends Resource


var id: int
var title: String
var salary: float


@warning_ignore("shadowed_variable")
func with_data(id: int, title: String, salary: float) -> JobPosition:
	self.id = id
	self.title = title
	self.salary = salary
	
	GlobalRefs.job_positions.append(self)
	GlobalRefs.job_positions_dict[id] = self
	
	return self


func to_dict() -> Dictionary:
	return {
		"id" = id,
		"title" = title,
		"salary" = salary,
	}


static func from_dict(data: Dictionary) -> JobPosition:
	return JobPosition.new().with_data(
		data["id"],
		data["title"],
		data["salary"],
	)


static func array_to_dict(data: Array[JobPosition]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: JobPosition in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[JobPosition]:
	var array: Array[JobPosition]
	for item: Dictionary in data:
		array.append(JobPosition.from_dict(item))
	return array
