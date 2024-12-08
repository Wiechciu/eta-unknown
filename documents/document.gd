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


func with_data(code_to_assign: Code, issued_time_to_assign: int, number_to_assign: int, shipment_to_assign: Shipment) -> Document:
	self.code = code_to_assign
	self.issued_time = issued_time_to_assign
	self.number = number_to_assign
	self.shipment = shipment_to_assign
	return self
