class_name Mailor
extends OsApp


const EMAIL_SUBJECTS: Array[String] = [
	"Shipment Delayed: New ETA Inside",
	"Important: Customs Documentation Update",
	"Weekly Logistics Performance Report",
	"New Carrier Rates Effective This Month",
	"Urgent: Freight Booking Confirmation Needed",
	"Port Congestion: Impact on Delivery Schedules",
	"New Warehouse Location Now Operational",
	"Reminder: Submit Packing List by EOD",
	"Q3 Supply Chain KPIs Released",
	"Action Required: Missing HS Codes",
	"Updated Incoterms Guidelines",
	"Reminder: Schedule Your Pickup Today",
	"Delivery Exception – Client Notification Sent",
	"Freight Invoice Attached – Please Review",
	"New Compliance Regulations in Effect",
	"Tracking Information for Order #8472",
	"Driver Assigned for Tomorrow’s Pickup",
	"POD (Proof of Delivery) Now Available",
	"Inventory Reconciliation Required",
	"Export Control Audit: Prep Checklist",
	"New 3PL Partnership Announcement",
	"Upcoming Warehouse Maintenance Downtime",
	"RFQ Submission Deadline Approaching",
	"Final Mile Carrier Change Notification",
	"Container Rolled Over – Next Vessel Info",
	"Monthly Logistics Newsletter – June Edition",
	"Dangerous Goods Certification Needed",
	"Book Your Spot: Logistics Strategy Webinar",
	"New Packaging Requirements from Supplier",
	"System Downtime Scheduled This Weekend",
	"Sailing Schedule Update – Asia-Europe Route",
	"Spot Quote Available for LTL Shipment",
	"Driver ETA Changed – Live Tracking Update",
	"Import Clearance Delay at Port",
	"Update: Shipment Transferred to Rail",
	"New Integration: TMS and WMS Sync Live",
	"Warehouse Inventory Levels Critical",
	"Annual Carrier Review – Your Feedback Needed",
	"Fuel Surcharge Increase Notification",
	"Backorder Fulfillment Expected This Week",
	"Client Return Shipment Request Received",
	"Hazmat Documentation Checklist",
	"Onboarding New Freight Forwarders",
	"Last-Mile Metrics Dashboard Launched",
	"Holiday Shipping Deadlines Reminder",
	"Packaging Compliance Audit Findings",
	"Supply Chain Risk Alert – Weather Advisory",
	"Proof of Export for Your Records",
	"New SLA Agreements Signed – Review Inside",
	"Time-Sensitive: Verify Shipment Dimensions",
	"Invitation: Global Logistics Summit 2025"
]

@export var inbox_items_container: Control
@export var sent_items_container: Control
@export var inbox_items: Array[EmailItem]
@export var sent_items: Array[EmailItem]

@export var email_item_scene: PackedScene
@export var attachment_item_scene: PackedScene

@export var account_info_Label: Label
@export var email_reader: Control
@export var email_reader_header_container: Control
@export var from_label: Label
@export var to_label: Label
@export var date_label: Label
@export var subject_label: Label
@export var body_label: RichTextLabel
@export var attachment_items_container_in_email_reader: Control
@export var attachment_items_container_in_email_composer: Control
var attachment_items_in_email_reader: Array[AttachmentItem]
var attachment_items_in_email_composer: Array[AttachmentItem]

@export var email_composer: Control
@export var to_edit: LineEdit
@export var subject_edit: LineEdit
@export var body_edit: TextEdit

@export var buttons_container: Control
@export var new_button: Button
@export var send_button: Button
@export var close_button: Button
@export var mark_as_unread_button: Button
@export var mark_as_read_button: Button
@export var reply_button: Button
@export var delete_button: Button
@export var add_to_person_button: Button
@export var add_subject_button: Button
@export var add_attachment_button: Button
@export var show_read_button: Button

var displayed_email_item: EmailItem
var original_email: Email


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	super._ready()
	EmailServer.email_registered.connect(_on_email_registered_on_server)
	account_info_Label.text = "Signed in as: %s" % logged_in_user.email
	clear_email_reader()
	clear_email_composer()
	clear_containers()
	retrieve_emails_from_server()
	register_buttons()
	filter_inbox()
	switch_to_email_reader()


func register_buttons() -> void:
	new_button.pressed.connect(_on_new_button_pressed)
	send_button.pressed.connect(_on_send_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	mark_as_unread_button.pressed.connect(_on_mark_as_unread_button_pressed)
	mark_as_read_button.pressed.connect(_on_mark_as_read_button_pressed)
	reply_button.pressed.connect(_on_reply_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)
	add_to_person_button.pressed.connect(_on_add_to_person_button_pressed)
	add_subject_button.pressed.connect(_on_add_subject_button_pressed)
	add_attachment_button.pressed.connect(_on_add_attachment_button_pressed)
	show_read_button.pressed.connect(_on_show_read_button_pressed)


func clear_containers() -> void:
	for child: Node in inbox_items_container.get_children():
		child.queue_free()
	inbox_items.clear()
	
	for child: Node in sent_items_container.get_children():
		child.queue_free()
	sent_items.clear()


func retrieve_emails_from_server() -> void:
	for email: Email in EmailServer.emails:
		add_email_item(email)


func add_email_item(email: Email) -> EmailItem:
	var new_email_item: EmailItem
	var items_array: Array[EmailItem]
	var items_container: Control
	if email.from == logged_in_user:
		new_email_item = create_email_item(email, false)
		items_array = sent_items
		items_container = sent_items_container
	else:
		new_email_item = create_email_item(email, true)
		items_array = inbox_items
		items_container = inbox_items_container
	items_array.append(new_email_item)
	items_container.add_child(new_email_item)
	items_container.move_child(new_email_item, 0)
	return new_email_item


func create_email_item(email: Email, is_inbound: bool) -> EmailItem:
	var new_email_item: EmailItem = email_item_scene.instantiate() as EmailItem
	new_email_item.initialize(email, is_inbound)
	new_email_item.opened.connect(switch_to_email_reader.bind(new_email_item))
	return new_email_item


func remove_email_item(email_item: EmailItem) -> void:
	if email_item == null:
		return
	
	inbox_items.erase(email_item)
	sent_items.erase(email_item)
	
	clear_email_reader()
	email_item.queue_free()


func add_all_attachment_items(email: Email, is_read_only: bool) -> void:
	for document: Document in email.attachments:
		add_attachment_item(document, is_read_only)


func add_attachment_item(document: Document, is_read_only: bool) -> AttachmentItem:
	var array: Array[AttachmentItem] = attachment_items_in_email_reader if is_read_only else attachment_items_in_email_composer
	var container: Control = attachment_items_container_in_email_reader if is_read_only else attachment_items_container_in_email_composer
	var new_attachment_item: AttachmentItem = create_attachment_item(document, is_read_only)
	array.append(new_attachment_item)
	container.add_child(new_attachment_item)
	return new_attachment_item


func create_attachment_item(document: Document, is_read_only: bool) -> AttachmentItem:
	var new_attachment_item: AttachmentItem = attachment_item_scene.instantiate() as AttachmentItem
	new_attachment_item.initialize(document, is_read_only)
	new_attachment_item.opened.connect(func() -> void: print("attachment pressed: " + new_attachment_item.document.document_data.name))
	new_attachment_item.removed.connect(_on_attachment_removed_button_pressed.bind(new_attachment_item))
	return new_attachment_item


func remove_attachment_item(attachment_item: AttachmentItem, is_read_only: bool) -> void:
	if attachment_item == null:
		return
	
	var array: Array[AttachmentItem] = attachment_items_in_email_reader if is_read_only else attachment_items_in_email_composer
	array.erase(attachment_item)
	attachment_item.queue_free()


func remove_all_attachment_items(is_read_only: bool) -> void:
	var array: Array[AttachmentItem] = attachment_items_in_email_reader if is_read_only else attachment_items_in_email_composer
	var container: Control = attachment_items_container_in_email_reader if is_read_only else attachment_items_container_in_email_composer
	for child: Node in container.get_children():
		child.queue_free()
	array.clear()


func clear_email_reader() -> void:
	if displayed_email_item != null:
		displayed_email_item.deselect()
		displayed_email_item = null
		filter_inbox()
	
	email_reader_header_container.hide()
	from_label.text = ""
	to_label.text = ""
	date_label.text = ""
	subject_label.text = ""
	body_label.text = ""
	remove_all_attachment_items(true)
	
	reply_button.hide()
	close_button.hide()
	mark_as_unread_button.hide()
	mark_as_read_button.hide()
	delete_button.hide()


func clear_email_composer() -> void:
	to_edit.text = ""
	subject_edit.text = ""
	body_edit.text = ""
	remove_all_attachment_items(false)


func display_email_in_reader(email_item: EmailItem) -> void:
	if displayed_email_item == email_item:
		return
	
	clear_email_reader()
	displayed_email_item = email_item
	displayed_email_item.select()
	displayed_email_item.set_to_read()
	
	email_reader_header_container.show()
	from_label.text = email_item.email.from.email
	to_label.text = email_item.email.to.email
	date_label.text = GlobalTimer.get_nice_datetime_string_from_unix_time(email_item.email.date)
	subject_label.text = email_item.email.subject
	body_label.text = email_item.email.body
	add_all_attachment_items(email_item.email, true)
	
	close_button.show()
	reply_button.show()
	delete_button.show()
	update_mark_buttons()


func update_mark_buttons() -> void:
	if displayed_email_item.is_inbound and displayed_email_item.email.is_read:
		mark_as_unread_button.show()
		mark_as_read_button.hide()
	elif displayed_email_item.is_inbound and displayed_email_item.email.is_unread:
		mark_as_unread_button.hide()
		mark_as_read_button.show()
	else:
		mark_as_unread_button.hide()
		mark_as_read_button.hide()


func _on_email_registered_on_server(email: Email) -> void:
	if email.from == logged_in_user or email.to == logged_in_user:
		add_email_item(email)


func _on_new_button_pressed() -> void:
	clear_email_composer()
	body_edit.text = EmailServer.get_footer(logged_in_user)
	original_email = null
	
	switch_to_email_composer()
	to_edit.grab_focus()


func _on_reply_button_pressed() -> void:
	clear_email_composer()
	if displayed_email_item.is_outbound:
		to_edit.text = displayed_email_item.email.to.email
	else:
		to_edit.text = displayed_email_item.email.from.email
	subject_edit.text = EmailServer.REPLY_SUBJECT_PREFIX + displayed_email_item.email.subject
	body_edit.text = EmailServer.add_footer_and_separator_to_beginning(displayed_email_item.email.body, logged_in_user)
	original_email = displayed_email_item.email
	
	switch_to_email_composer()
	body_edit.grab_focus()


func _on_send_button_pressed() -> void:
	if to_edit.text == "" or subject_edit.text == "":
		ActionLogger.create_error("Need to fill in 'To' and 'Subject' fields")
		return
	
	var to_person: Person = Person.get_person_by_email(to_edit.text)
	if to_person == null:
		ActionLogger.create_error("Can't find email '%s' in the directory!" % to_edit.text)
		return
	
	var attached_documents: Array[Document]
	for attachment_item: AttachmentItem in attachment_items_in_email_composer:
		attached_documents.append(attachment_item.document)
	
	var new_email: Email = Email.create_new(
		logged_in_user,
		to_person,
		subject_edit.text,
		body_edit.text,
		GlobalTimer.now,
		attached_documents,
		original_email
	)
	
	EmailServer.register_email(new_email)
	switch_to_email_reader(sent_items.back())


func _on_close_button_pressed() -> void:
	clear_email_reader()


func _on_mark_as_unread_button_pressed() -> void:
	if displayed_email_item == null:
		return
	displayed_email_item.set_to_unread()
	update_mark_buttons()


func _on_mark_as_read_button_pressed() -> void:
	if displayed_email_item == null:
		return
	displayed_email_item.set_to_read()
	update_mark_buttons()


func _on_delete_button_pressed() -> void:
	remove_email_item(displayed_email_item)


#TODO: Implement proper logic of selecting people.
func _on_add_to_person_button_pressed() -> void:
	to_edit.text = ""
	var tween: Tween = create_tween()
	tween.tween_property(to_edit, "text", GlobalRefs.people.pick_random().email, 0.5)


#TODO: Implement proper logic of selecting subject types.
func _on_add_subject_button_pressed() -> void:
	subject_edit.text = ""
	var tween: Tween = create_tween()
	tween.tween_property(subject_edit, "text", EMAIL_SUBJECTS.pick_random(), 0.5)


#TODO: Implement proper logic of selecting attachments from shipments.
func _on_add_attachment_button_pressed() -> void:
	var new_document: Document = Document.create_new((GlobalRefs.documents.pick_random() as DocumentData).code, GlobalTimer.now, randi_range(1000, 100000))
	add_attachment_item(new_document, false)


func _on_attachment_removed_button_pressed(attachment_item: AttachmentItem) -> void:
	remove_attachment_item(attachment_item, false)


func _on_show_read_button_pressed() -> void:
	filter_inbox()


func filter_inbox() -> void:
	for email_item: EmailItem in inbox_items:
		if email_item.email.is_unread or email_item.email.is_read and show_read_button.button_pressed or email_item.is_selected:
			email_item.show()
		else:
			email_item.hide()


func switch_to_email_reader(email_item: EmailItem = null) -> void:
	email_reader.show()
	buttons_container.show()
	
	email_composer.hide()
	send_button.hide()
	add_attachment_button.hide()
	
	if email_item != null:
		display_email_in_reader(email_item)


func switch_to_email_composer() -> void:
	email_composer.show()
	send_button.show()
	add_attachment_button.show()
	
	email_reader.hide()
	buttons_container.hide()
	
	clear_email_reader()
