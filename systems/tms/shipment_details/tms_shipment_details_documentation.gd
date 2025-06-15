class_name TmsShipmentDetailsDocumentation
extends PanelContainer


signal document_print_ordered(document: Document, print_type: Document.PrintType)


var shipment: Shipment

@export var print_all_button: Button
@export var print_selected_button: Button
@export var documents_container: Control
@export var document_details_scene: PackedScene


func _init() -> void:
	visibility_changed.connect(_on_visibility_changed)


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	
	print_all_button.pressed.connect(_on_print_all_button_pressed)
	print_selected_button.pressed.connect(_on_print_selected_button_pressed)


func _on_visibility_changed() -> void:
	if visible and shipment:
		refresh()
	
	if not visible and shipment != null and shipment.documentation.documentation_updated.is_connected(refresh):
		shipment.documentation.documentation_updated.disconnect(refresh)


func refresh() -> void:
	load_shipment(shipment)


func load_shipment(shipment_to_load: Shipment) -> void:
	shipment = shipment_to_load
	
	if not shipment.documentation.documentation_updated.is_connected(refresh):
		shipment.documentation.documentation_updated.connect(refresh)
	
	refresh_document_details(shipment.documentation.documents)


func refresh_document_details(documents: Array[Document]) -> void:
	for child: Node in documents_container.get_children():
		child.queue_free()
	
	for document: Document in documents:
		var document_details: TmsDocumentDetails = (document_details_scene.instantiate() as TmsDocumentDetails).with_data(document)
		documents_container.add_child(document_details)


func _on_print_all_button_pressed() -> void:
	var documents_to_print: Array[Document] = shipment.documentation.documents
	var labels_to_print: Array[Document] = shipment.documentation.documents.filter(func(document: Document) -> bool: return Document.DOCUMENTS_WITH_LABELS.has(document.document_data.code))
	
	print_documents(documents_to_print, labels_to_print)


func _on_print_selected_button_pressed() -> void:
	var documents_to_print: Array[Document]
	var labels_to_print: Array[Document]
	for child: Node in documents_container.get_children():
		var document_details: TmsDocumentDetails = child as TmsDocumentDetails
		if document_details.document_check_box.button_pressed:
			documents_to_print.append(document_details.document)
		if document_details.label_check_box.button_pressed:
			labels_to_print.append(document_details.document)
	
	print_documents(documents_to_print, labels_to_print)


func print_documents(documents_to_print: Array[Document], labels_to_print: Array[Document]) -> void:
	if documents_to_print.size() == 0 and labels_to_print.size() == 0:
		ActionLogger.create_log("NO_DOCUMENTS_TO_PRINT", true)
		return
	
	for document_to_print: Document in documents_to_print:
		document_print_ordered.emit(document_to_print, Document.PrintType.DOCUMENT)
	
	for label_to_print: Document in labels_to_print:
		document_print_ordered.emit(label_to_print, Document.PrintType.LABEL)
