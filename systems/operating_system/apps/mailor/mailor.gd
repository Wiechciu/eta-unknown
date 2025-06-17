class_name Mailor
extends OsApp


@export var inbox_item_container: Control
@export var sent_item_container: Control
@export var inbox_items: Array[EmailItem]
@export var sent_items: Array[EmailItem]

@export var email_item_scene: PackedScene

@export var email_reader: Control
@export var from_label: Label
@export var to_label: Label
@export var date_label: Label
@export var subject_label: Label
@export var body_label: RichTextLabel

@export var email_composer: Control
@export var to_edit: LineEdit
@export var subject_edit: LineEdit
@export var body_edit: TextEdit

@export var new_button: Button
@export var send_button: Button
@export var unread_button: Button
@export var reply_button: Button
@export var delete_button: Button

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
	super._ready()
	clear_email_reader_labels()
	clear_email_composer_labels()
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


func clear_containers() -> void:
	for child: Node in inbox_item_container.get_children():
		child.queue_free()
	inbox_items.clear()
	
	for child: Node in sent_item_container.get_children():
		child.queue_free()
	sent_items.clear()


func populate_containers() -> void:
	for email: Email in EmailServer.emails:
		add_item(email)


func add_item(email: Email) -> EmailItem:
	var new_email_item: EmailItem = create_item(email)
	var item_array: Array[EmailItem]
	var item_container: Control
	if email.from == GameManager.player.person.email:
		item_array = sent_items
		item_container = sent_item_container
	else:
		item_array = inbox_items
		item_container = inbox_item_container
	item_array.append(new_email_item)
	item_container.add_child(new_email_item)
	item_container.move_child(new_email_item, 0)
	return new_email_item


func create_item(email: Email) -> EmailItem:
	var new_email_item: EmailItem = email_item_scene.instantiate() as EmailItem
	new_email_item.initialize(email)
	new_email_item.opened.connect(switch_to_email_reader.bind(new_email_item))
	return new_email_item


func remove_item(email_item: EmailItem) -> void:
	if email_item == null:
		return
	
	inbox_items.erase(email_item)
	sent_items.erase(email_item)
	
	clear_email_reader_labels()
	email_item.queue_free()


func clear_email_reader_labels() -> void:
	displayed_email_item = null
	from_label.text = ""
	to_label.text = ""
	date_label.text = ""
	subject_label.text = ""
	body_label.text = ""
	
	reply_button.hide()
	unread_button.hide()
	delete_button.hide()


func clear_email_composer_labels() -> void:
	to_edit.text = ""
	subject_edit.text = ""
	body_edit.text = ""


func display_email_in_reader(email_item: EmailItem) -> void:
	displayed_email_item = email_item
	from_label.text = email_item.email.from
	to_label.text = email_item.email.to
	date_label.text = GlobalTimer.get_nice_datetime_string_from_unix_time(email_item.email.date)
	subject_label.text = email_item.email.subject
	body_label.text = email_item.email.body
	
	reply_button.show()
	delete_button.show()
	
	if inbox_items.has(email_item):
		unread_button.show()
	else:
		unread_button.hide()


func _on_new_button_pressed() -> void:
	clear_email_composer_labels()
	body_edit.text = footer
	
	switch_to_email_composer()
	to_edit.grab_focus()


func _on_reply_button_pressed() -> void:
	clear_email_composer_labels()
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
	
	var new_email: Email = Email.create_new(
		GameManager.player.person.email,
		to_edit.text,
		subject_edit.text,
		body_edit.text,
		GlobalTimer.now
	)
	
	EmailServer.register_email(new_email)
	var new_email_item: EmailItem = add_item(new_email)
	
	switch_to_email_reader(new_email_item)


func _on_unread_button_pressed() -> void:
	if displayed_email_item == null:
		return
	displayed_email_item.set_to_unread()


func _on_delete_button_pressed() -> void:
	remove_item(displayed_email_item)


func switch_to_email_reader(email_item: EmailItem = null) -> void:
	email_reader.show()
	new_button.show()
	
	email_composer.hide()
	send_button.hide()
	
	if email_item != null:
		display_email_in_reader(email_item)


func switch_to_email_composer() -> void:
	email_composer.show()
	send_button.show()
	
	email_reader.hide()
	new_button.hide()
	delete_button.hide()
	unread_button.hide()
	reply_button.hide()
