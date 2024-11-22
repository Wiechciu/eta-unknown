extends OptionButton


func _init() -> void:
	for shipment_status in Shipment.Status.keys():
		add_item(shipment_status)
	
	
	select(Shipment.Status.COMPLETED)
