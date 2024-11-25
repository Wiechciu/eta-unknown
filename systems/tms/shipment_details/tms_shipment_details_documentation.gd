class_name TmsShipmentDetailsDocumentation
extends PanelContainer


var shipment: Shipment

@export var _documents_container: Control
@export var _document_details_scene: PackedScene


func _init() -> void:
	visibility_changed.connect(_on_visibility_changed)


func _ready() -> void:
	Debugger.assert_all_exported_properties(self)


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
	
	refresh_document_details(_documents_container, shipment.documentation.documents)


func refresh_document_details(document_details_container: Control, documents: Array[Document]) -> void:
	for child: Node in document_details_container.get_children():
		child.queue_free()
	
	for document: Document in documents:
		var document_details: TmsDocumentDetails = (_document_details_scene.instantiate() as TmsDocumentDetails).with_data(document)
		document_details_container.add_child(document_details)
