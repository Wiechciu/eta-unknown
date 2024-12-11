class_name Country
extends Resource


@export_storage var id: int
@export_storage var code: String
@export_storage var name: String
var locations: Array[Location]


@warning_ignore("shadowed_variable")
func with_data(id: int, code: String, name: String) -> Country:
	self.id = id
	self.code = code
	self.name = name
	
	return self
