class_name Cargo
extends Resource


@export var id: int
@export var description: String
@export var hs_code: String
@export var unit_value: float
@export var unit_size: float
@export var unit_weight: float


@warning_ignore("shadowed_variable")
static func create_new(id: int, description: String, hs_code: String, unit_value: float, unit_size: float, unit_weight: float) -> Cargo:
	var new_cargo: Cargo = Cargo.new()
	new_cargo.id = id
	new_cargo.description = description
	new_cargo.hs_code = hs_code
	new_cargo.unit_value = unit_value
	new_cargo.unit_size = unit_size
	new_cargo.unit_weight = unit_weight
	
	GlobalRefs.cargos.append(new_cargo)
	
	return new_cargo


#func to_dict() -> Dictionary:
	#return {
		#"id" = id,
		#"description" = description,
		#"hs_code" = hs_code,
		#"unit_value" = unit_value,
		#"unit_size" = unit_size,
		#"unit_weight" = unit_weight,
	#}
#
#
#static func from_dict(data: Dictionary) -> Cargo:
	#return Cargo.new().with_data(
		#data["id"],
		#data["description"],
		#data["hs_code"],
		#data["unit_value"],
		#data["unit_size"],
		#data["unit_weight"],
	#)
#
#
#static func array_to_dict(data: Array[Cargo]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: Cargo in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[Cargo]:
	#var array: Array[Cargo]
	#for item: Dictionary in data:
		#array.append(Cargo.from_dict(item))
	#return array
