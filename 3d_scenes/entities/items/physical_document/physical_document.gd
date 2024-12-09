class_name PhysicalDocument
extends Item


var document: Document


func with_data(document_to_assign: Document) -> PhysicalDocument:
	document = document_to_assign
	return self
