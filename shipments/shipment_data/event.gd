class_name Event
extends Resource


enum Code {
	BOK,
	ERL,
	PUP,
	RCV,
	CSE,
	DEP,
	ARR,
	CSI,
	REL,
	DEL,
	LTS,
}

enum Type {
	PLANNED,
	ACTUAL,
}


var code: Code
var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		return "EVENT_" + code_string
var type: Type
var time: int
var location: Location


@warning_ignore("shadowed_variable")
func with_data(code: Code, type: Type, time: int, location: Location = null) -> Event:
	self.code = code
	self.type = type
	self.time = time
	self.location = location
	return self


func to_dict() -> Dictionary:
	return {
		"code" = code,
		"type" = type,
		"time" = time,
		"location_id" = str(location.id) if location else "",
	}


static func from_dict(data: Dictionary) -> Event:
	return Event.new().with_data(
		data.code,
		data.type,
		data.time,
		GlobalRefs.locations[data.location_id as int] if data.location_id else null,
	)


static func array_to_dict(data: Array[Event]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Event in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Event]:
	var array: Array[Event]
	for item: Dictionary in data:
		array.append(Event.from_dict(item))
	return array
