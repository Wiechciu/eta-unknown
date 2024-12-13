class_name PhysicalDocument
extends Item


var document: Document
var signed_by: Person
var is_signed: bool:
	get: return signed_by != null


@warning_ignore("shadowed_variable")
func with_data(document: Document) -> PhysicalDocument:
	self.document = document
	
	return self


func sign_document(person: Person) -> void:
	signed_by = person
