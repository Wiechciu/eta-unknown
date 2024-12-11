class_name PhysicalDocument
extends Item


var document: Document


@warning_ignore("shadowed_variable")
func with_data(document: Document) -> PhysicalDocument:
	self.document = document
	
	return self
