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
		match code:
			Code.RFQ: return "Request for quotation"
			Code.QUO: return "Quotation"
			Code.SPO: return "Shipping order"
			Code.HWB: return "House Air Waybill"
			Code.MWB: return "Master Air Waybill"
			Code.HBL: return "House Bill of Lading"
			Code.MBL: return "Master Bill of Lading"
			Code.CDE: return "Customs Declaration Export"
			Code.CDI: return "Customs Declaration Import"
			Code.PUO: return "Pickup order"
			Code.DLO: return "Delivery order"
			Code.POD: return "Proof of delivery"
			Code.CIN: return "Commercial invoice"
			Code.PKL: return "Packing list"
			Code.MSD: return "Material safety data sheet"
			Code.DGD: return "Dangerous goods declaration"
			_: return "%s - unknown document" % code_string
var issued_time: int
var number: int

var shipment: Shipment


func with_data(code_to_assign: Code, issued_time_to_assign: int, number_to_assign: int, shipment_to_assign: Shipment) -> Document:
	self.code = code_to_assign
	self.issued_time = issued_time_to_assign
	self.number = number_to_assign
	self.shipment = shipment_to_assign
	return self
