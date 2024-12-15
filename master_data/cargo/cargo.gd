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


func to_dict() -> Dictionary:
	return {
		"id" = id,
		"description" = description,
		"hs_code" = hs_code,
		"unit_value" = unit_value,
		"unit_size" = unit_size,
		"unit_weight" = unit_weight,
	}


static func from_dict(data: Dictionary) -> Cargo:
	return Cargo.new().with_data(
		data["id"],
		data["description"],
		data["hs_code"],
		data["unit_value"],
		data["unit_size"],
		data["unit_weight"],
	)


static func array_to_dict(data: Array[Cargo]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Cargo in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Cargo]:
	var array: Array[Cargo]
	for item: Dictionary in data:
		array.append(Cargo.from_dict(item))
	return array
