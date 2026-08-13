class_name Gender
extends Resource


@export var gender_name: String
@export var gender_icon: Texture2D


static func get_by_name(name: String) -> Gender:
	for gender: Gender in GlobalRefs.genders:
		if gender.gender_name.to_lower() == name.to_lower():
			return gender
	
	printerr("Couldn't find gender: " + name)
	return null
