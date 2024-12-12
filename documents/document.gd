class_name Document
extends Resource


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


@export_storage var code: Code
var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		return tr("DOCUMENT_" + code_string)
@export_storage var issued_time: int
@export_storage var number: int


@warning_ignore("shadowed_variable")
func with_data(code: Code, issued_time: int, number: int) -> Document:
	self.code = code
	self.issued_time = issued_time
	self.number = number
	return self
