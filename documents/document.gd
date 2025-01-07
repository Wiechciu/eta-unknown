class_name Document
extends Resource


enum PrintType {
	DOCUMENT,
	LABEL,
}

enum Code {
	RFQ,
	QUO,
	SPO,
	HWB,
	MWB,
	HBL,
	MBL,
	CDE,
	CDI,
	PUO,
	DLO,
	POD,
	CIN,
	PKL,
	MSD,
	DGD,
}

const DOCUMENTS_WITH_LABELS: Array[Document.Code] = [
	Code.HWB,
	Code.MWB,
	Code.HBL,
	Code.MBL,
]

var code: Code
var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		return "DOCUMENT_" + code_string
var issued_time: int
var number: int


@warning_ignore("shadowed_variable")
func with_data(code: Code, issued_time: int, number: int) -> Document:
	self.code = code
	self.issued_time = issued_time
	self.number = number
	return self


func to_dict() -> Dictionary:
	return {
		"code" = code,
		"issued_time" = issued_time,
		"number" = number,
	}


static func from_dict(data: Dictionary) -> Document:
	return Document.new().with_data(
		data["code"],
		data["issued_time"],
		data["number"],
	)


static func array_to_dict(data: Array[Document]) -> Array[Dictionary]:
	var array: Array[Dictionary]
	for item: Document in data:
		array.append(item.to_dict())
	return array


static func array_from_dict(data: Array) -> Array[Document]:
	var array: Array[Document]
	for item: Dictionary in data:
		array.append(Document.from_dict(item))
	return array
