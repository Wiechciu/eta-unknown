class_name Cargo
extends Resource


var id: int
var description: String
var hs_code: String
var unit_value: float
var unit_size: float
var unit_weight: float


@warning_ignore("shadowed_variable")
func with_data(id: int, description: String, hs_code: String, unit_value: float, unit_size: float, unit_weight: float) -> Cargo:
	self.id = id
	self.description = description
	self.hs_code = hs_code
	self.unit_value = unit_value
	self.unit_size = unit_size
	self.unit_weight = unit_weight
	
	return self
