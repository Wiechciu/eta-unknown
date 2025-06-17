class_name Mailor
extends OsApp


@export var inbox_items_container: Control
@export var sent_items_container: Control
@export var inbox_items: Array[EmailItem]
@export var sent_items: Array[EmailItem]

@export var email_item_scene: PackedScene
@export var attachment_item_scene: PackedScene

@export var email_reader: Control
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
@export var unread_button: Button
@export var reply_button: Button
@export var delete_button: Button
@export var add_attachment_button: Button

var displayed_email_item: EmailItem
var line_break: String = "\n"
var email_separator: String = "______________________________"
var footer: String:
	get:
		return line_break \
		+ line_break + "Best regards," \
		+ line_break + GameManager.player.person.full_name \
		+ line_break + GameManager.player.person.job_position.title \
		+ line_break + GameManager.player.person.email \
		+ line_break + GameManager.player.person.phone_number \
		+ line_break + GameManager.player.person.employer.print_string


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	super._ready()
	clear_email_reader()
	clear_email_composer()
	clear_containers()
	populate_containers()
	register_buttons()
	switch_to_email_reader()


func register_buttons() -> void:
	new_button.pressed.connect(_on_new_button_pressed)
	send_button.pressed.connect(_on_send_button_pressed)
	unread_button.pressed.connect(_on_unread_button_pressed)
	reply_button.pressed.connect(_on_reply_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)
	add_attachment_button.pressed.connect(_on_add_attachment_button_pressed)


func clear_containers() -> void:
	for child: Node in inbox_items_container.get_children():
		child.queue_free()
	inbox_items.clear()
	
	for child: Node in sent_items_container.get_children():
		child.queue_free()
	sent_items.clear()


func populate_containers() -> void:
	for email: Email in EmailServer.emails:
		add_email_item(email)


func add_email_item(email: Email) -> EmailItem:
	var new_email_item: EmailItem
	var items_array: Array[EmailItem]
	var items_container: Control
	if email.from == GameManager.player.person.email:
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


func create_email_item(email: Email, inbound: bool) -> EmailItem:
	var new_email_item: EmailItem = email_item_scene.instantiate() as EmailItem
	new_email_item.initialize(email, inbound)
	new_email_item.opened.connect(switch_to_email_reader.bind(new_email_item))
	return new_email_item


func remove_email_item(email_item: EmailItem) -> void:
	if email_item == null:
		return
	
	inbox_items.erase(email_item)
	sent_items.erase(email_item)
	
	clear_email_reader()
	email_item.queue_free()


func add_all_attachment_items(email: Email, container: Control, array: Array[AttachmentItem]) -> void:
	for document: Document in email.attachments:
		add_attachment_item(document, container, array)


func add_attachment_item(document: Document, container: Control, array: Array[AttachmentItem]) -> AttachmentItem:
	var new_attachment_item: AttachmentItem = create_attachment_item(document)
	array.append(new_attachment_item)
	container.add_child(new_attachment_item)
	return new_attachment_item


func create_attachment_item(document: Document) -> AttachmentItem:
	var new_attachment_item: AttachmentItem = attachment_item_scene.instantiate() as AttachmentItem
	new_attachment_item.initialize(document)
	new_attachment_item.opened.connect(func() -> void: print("attachment pressed: " + new_attachment_item.document.document_data.name))
	return new_attachment_item


func remove_attachment_item(attachment_item: AttachmentItem, array: Array[AttachmentItem]) -> void:
	if attachment_item == null:
		return
	
	array.erase(attachment_item)
	attachment_item.queue_free()


func remove_all_attachment_items(container: Control, array: Array[AttachmentItem]) -> void:
	for child: Node in container.get_children():
		child.queue_free()
	array.clear()


func clear_email_reader() -> void:
	if displayed_email_item != null:
		displayed_email_item.deselect()
		displayed_email_item = null
	from_label.text = ""
	to_label.text = ""
	date_label.text = ""
	subject_label.text = ""
	body_label.text = ""
	remove_all_attachment_items(attachment_items_container_in_email_reader, attachment_items_in_email_reader)
	
	reply_button.hide()
	unread_button.hide()
	delete_button.hide()


func clear_email_composer() -> void:
	to_edit.text = ""
	subject_edit.text = ""
	body_edit.text = ""
	remove_all_attachment_items(attachment_items_container_in_email_composer, attachment_items_in_email_composer)


func display_email_in_reader(email_item: EmailItem) -> void:
	clear_email_reader()
	displayed_email_item = email_item
	displayed_email_item.select()
	
	from_label.text = email_item.email.from
	to_label.text = email_item.email.to
	date_label.text = GlobalTimer.get_nice_datetime_string_from_unix_time(email_item.email.date)
	subject_label.text = email_item.email.subject
	body_label.text = email_item.email.body
	add_all_attachment_items(email_item.email, attachment_items_container_in_email_reader, attachment_items_in_email_reader)
	
	reply_button.show()
	delete_button.show()
	
	if inbox_items.has(email_item):
		unread_button.show()
	else:
		unread_button.hide()


func _on_new_button_pressed() -> void:
	clear_email_composer()
	body_edit.text = footer
	
	switch_to_email_composer()
	to_edit.grab_focus()


func _on_reply_button_pressed() -> void:
	clear_email_composer()
	if displayed_email_item.email.from == GameManager.player.person.email:
		to_edit.text = displayed_email_item.email.to
	else:
		to_edit.text = displayed_email_item.email.from
	subject_edit.text = "RE: " + displayed_email_item.email.subject
	body_edit.text = footer \
	+ line_break \
	+ line_break + email_separator \
	+ line_break + displayed_email_item.email.body
	
	switch_to_email_composer()
	body_edit.grab_focus()


func _on_send_button_pressed() -> void:
	if to_edit.text == "" or subject_edit.text == "":
		ActionLogger.create_log("Need to fill in 'To' and 'Subject' fields", true)
		return
	
	var attached_documents: Array[Document]
	for attachment_item: AttachmentItem in attachment_items_in_email_composer:
		attached_documents.append(attachment_item.document)
	
	var new_email: Email = Email.create_new(
		GameManager.player.person.email,
		to_edit.text,
		subject_edit.text,
		body_edit.text,
		GlobalTimer.now,
		attached_documents
	)
	
	EmailServer.register_email(new_email)
	var new_email_item: EmailItem = add_email_item(new_email)
	
	switch_to_email_reader(new_email_item)


func _on_unread_button_pressed() -> void:
	if displayed_email_item == null:
		return
	displayed_email_item.set_to_unread()


func _on_delete_button_pressed() -> void:
	remove_email_item(displayed_email_item)


#TODO: Implement proper logic of selecting attachments from shipments.
func _on_add_attachment_button_pressed() -> void:
	var new_document: Document = Document.create_new((GlobalRefs.documents.pick_random() as DocumentData).code, GlobalTimer.now, randi_range(1000, 100000))
	add_attachment_item(new_document, attachment_items_container_in_email_composer, attachment_items_in_email_composer)


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
