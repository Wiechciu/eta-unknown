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


var code: Code
var code_string: String:
	get:
		return Code.keys()[code]
var name: String:
	get:
		return tr("DOCUMENT_" + code_string)
var issued_time: int
var number: int

var shipment: Shipment


@warning_ignore("shadowed_variable")
func with_data(code: Code, issued_time: int, number: int, shipment: Shipment) -> Document:
	self.code = code
	self.issued_time = issued_time
	self.number = number
	self.shipment = shipment
	return self
