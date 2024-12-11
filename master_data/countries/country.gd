class_name Country
extends Resource


var id: int
var code: String
var name: String
var locations: Array[Location]


@warning_ignore("shadowed_variable")
func with_data(id: int, code: String, name: String) -> Country:
	self.id = id
	self.code = code
	self.name = name
	
	return self
