class_name Cargo
extends Resource


@export_storage var id: int
@export_storage var description: String
@export_storage var hs_code: String
@export_storage var unit_value: float
@export_storage var unit_size: float
@export_storage var unit_weight: float


@warning_ignore("shadowed_variable")
func with_data(id: int, description: String, hs_code: String, unit_value: float, unit_size: float, unit_weight: float) -> Cargo:
	self.id = id
	self.description = description
	self.hs_code = hs_code
	self.unit_value = unit_value
	self.unit_size = unit_size
	self.unit_weight = unit_weight
	
	return self
