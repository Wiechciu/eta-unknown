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


var code: Code
var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		return tr("EVENT_" + code_string)
var time: int
var location: Location
