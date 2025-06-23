class_name Mailor
extends OsApp


signal items_count_changed


@export var inbox_items_container: Control
@export var sent_items_container: Control
@export var inbox_items: Array[EmailItem]
var unread_inbox_items: Array[EmailItem]:
	get:
		return inbox_items.filter(func(email_item: EmailItem) -> bool: return email_item.email.is_unread)
@export var sent_items: Array[EmailItem]

@export var email_item_scene: PackedScene
@export var attachment_item_scene: PackedScene

@export var account_info_Label: Label
@export var search_edit: LineEdit
@export var search_delay_timer: Timer
var search_call_id: int

@export var email_reader: Control
@export var email_reader_header_container: Control
@export var from_label: Label
@export var to_label: Label
@export var date_label: Label
@export var subject_label: Label
@export var body_label: RichTextLabel
@export var body_label_container: Control
@export var attachment_container_in_email_reader: Control
@export var attachment_items_container_in_email_reader: Control
@export var attachment_items_container_in_email_composer: Control
var attachment_items_in_email_reader: Array[AttachmentItem]
var attachment_items_in_email_composer: Array[AttachmentItem]

@export var attachment_reader: Control

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
	clear_attachment_reader()
	clear_email_composer()
	clear_containers()
	retrieve_emails_from_server()
	register_signals()
	filter_inbox()
	switch_to_email_reader()


func register_signals() -> void:
	search_edit.text_changed.connect(_on_search_text_changed.unbind(1))
	search_edit.text_submitted.connect(_on_search_text_submitted.unbind(1))
	
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
	show_or_hide_email_item(new_email_item)
	items_count_changed.emit()
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
	clear_attachment_reader()
	
	email_item.queue_free()
	items_count_changed.emit()


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
	new_attachment_item.opened.connect(_on_attachment_opened_button_pressed.bind(new_attachment_item))
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
	body_label.scroll_to_line(0)
	remove_all_attachment_items(true)
	
	reply_button.hide()
	close_button.hide()
	mark_as_unread_button.hide()
	mark_as_read_button.hide()
	delete_button.hide()


func clear_attachment_reader() -> void:
	for child: Node in attachment_reader.get_children():
		child.queue_free()


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
	items_count_changed.emit()
	
	email_reader_header_container.show()
	from_label.text = email_item.email.from.email
	to_label.text = email_item.email.to.email
	date_label.text = GlobalTimer.get_nice_datetime_string_from_unix_time(email_item.email.date)
	subject_label.text = email_item.email.subject
	body_label.text = email_item.email.body
	if email_item.email.attachments.is_empty():
		attachment_container_in_email_reader.hide()
	else:
		attachment_container_in_email_reader.show()
		add_all_attachment_items(email_item.email, true)
	
	close_button.show()
	reply_button.show()
	delete_button.show()
	update_mark_buttons()


func display_attachment_in_reader(attachment_item: AttachmentItem) -> void:
	clear_attachment_reader()
	if attachment_item.document.document_data.document_layout == null:
		printerr("No document layout assigned")
		ActionLogger.create_error("Cannot open attachment!")
		return
	var document_layout: DocumentLayout = attachment_item.document.document_data.document_layout.instantiate() as DocumentLayout
	document_layout.initialize(attachment_item.document, attachment_item.name_label.text)
	attachment_reader.add_child(document_layout)
	document_layout.closed.connect(switch_to_email_reader.bind(displayed_email_item))
	
	attachment_reader.show()
	body_label_container.hide()


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


func _on_search_text_changed() -> void:
	search_call_id += 1
	var current_search_call_id: int = search_call_id
	
	search_delay_timer.start()
	await search_delay_timer.timeout
	
	if current_search_call_id == search_call_id:
		filter_inbox()


func _on_search_text_submitted() -> void:
	search_call_id += 1
	filter_inbox()


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
	clear_attachment_reader()


func _on_mark_as_unread_button_pressed() -> void:
	if displayed_email_item == null:
		return
	displayed_email_item.set_to_unread()
	items_count_changed.emit()
	update_mark_buttons()


func _on_mark_as_read_button_pressed() -> void:
	if displayed_email_item == null:
		return
	displayed_email_item.set_to_read()
	items_count_changed.emit()
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
	tween.tween_property(subject_edit, "text", EmailServer.EMAIL_SUBJECTS.pick_random(), 0.5)


#TODO: Implement proper logic of selecting attachments from shipments.
func _on_add_attachment_button_pressed() -> void:
	var new_document: Document = Document.create_new((GlobalRefs.documents.pick_random() as DocumentData).code, GlobalTimer.now, randi_range(1000, 100000), Shipment.create_new_with_random_data())
	add_attachment_item(new_document, false)


func _on_attachment_opened_button_pressed(attachment_item: AttachmentItem) -> void:
	display_attachment_in_reader(attachment_item)


func _on_attachment_removed_button_pressed(attachment_item: AttachmentItem) -> void:
	remove_attachment_item(attachment_item, false)


func _on_show_read_button_pressed() -> void:
	filter_inbox()


func filter_inbox() -> void:
	for email_item: EmailItem in inbox_items:
		show_or_hide_email_item(email_item)
	items_count_changed.emit()


func show_or_hide_email_item(email_item: EmailItem) -> void:
	if(check_email_item_to_show_or_hide(email_item)):
		email_item.show()
	else:
		email_item.hide()


func check_email_item_to_show_or_hide(email_item: EmailItem) -> bool:
	return \
		#Read/unread check
		(email_item.email.is_unread \
		or email_item.email.is_read and show_read_button.button_pressed \
		or email_item.is_selected) \
		#Search text check #TODO: parse the search box text to look for keywords, e.g. from:xyz, subject:xyz
		and ((email_item.email.subject.containsn(search_edit.text) if search_edit.text != "" else true) \
		or (email_item.email.body.containsn(search_edit.text) if search_edit.text != "" else true) \
		or (email_item.email.from.email.containsn(search_edit.text) if search_edit.text != "" else true))


func switch_to_email_reader(email_item: EmailItem = null) -> void:
	email_reader.show()
	attachment_reader.hide()
	buttons_container.show()
	body_label_container.show()
	
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
	attachment_reader.hide()
	buttons_container.hide()
	
	clear_email_reader()
