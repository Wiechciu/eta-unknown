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
	
	return self
