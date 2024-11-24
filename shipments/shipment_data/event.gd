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
		match code:
			Code.BOK: return "Received booking"
			Code.ERL: return "Earliest pickup"
			Code.PUP: return "Picked up"
			Code.RCV: return "Received at origin"
			Code.CSE: return "Export customs cleared"
			Code.DEP: return "Departed"
			Code.ARR: return "Arrived"
			Code.CSI: return "Import customs cleared"
			Code.REL: return "Released for delivery"
			Code.DEL: return "Delivered"
			Code.LTS: return "Latest delivery"
			_: return "%s - unknown event" % code_string
var time: int
var location: Location
