class_name Incoterms
extends Resource


static var all: Array[Incoterms]
static var all_dict: Dictionary[String, Incoterms]


var code: String
var name: String
var group: String:
	get:
		return code.left(1)
