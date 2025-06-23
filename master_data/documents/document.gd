class_name Document
extends Resource


enum PrintType {
	DOCUMENT,
	LABEL,
}


const DOCUMENTS_WITH_LABELS: Array[String] = [
	"HWB",
	"MWB",
	"HBL",
	"MBL",
]


@export var document_data: DocumentData
@export var issued_time: int
@export var number: int
@export var shipment: Shipment


@warning_ignore("shadowed_variable")
static func create_new(code: String, issued_time: int, number: int, shipment: Shipment) -> Document:
	var new_document: Document = Document.new()
	new_document.document_data = DocumentData.get_document_by_code(code)
	new_document.issued_time = issued_time
	new_document.number = number
	new_document.shipment = shipment
	return new_document


#@warning_ignore("shadowed_variable")
#func with_data(code: Code, issued_time: int, number: int) -> Document:
	#self.code = code
	#self.issued_time = issued_time
	#self.number = number
	#return self


#func to_dict() -> Dictionary:
	#return {
		#"code" = code,
		#"issued_time" = issued_time,
		#"number" = number,
	#}
#
#
#static func from_dict(data: Dictionary) -> Document:
	#return Document.new().with_data(
		#data["code"],
		#data["issued_time"],
		#data["number"],
	#)
#
#
#static func array_to_dict(data: Array[Document]) -> Array[Dictionary]:
	#var array: Array[Dictionary]
	#for item: Document in data:
		#array.append(item.to_dict())
	#return array
#
#
#static func array_from_dict(data: Array) -> Array[Document]:
	#var array: Array[Document]
	#for item: Dictionary in data:
		#array.append(Document.from_dict(item))
	#return array
