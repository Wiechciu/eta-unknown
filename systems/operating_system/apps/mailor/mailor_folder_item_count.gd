extends Label


enum FolderType {
	INBOX,
	SENT,
}


@export var folder_type: FolderType
var mailor: Mailor
var inbox_items_count: int
var visible_inbox_items_count: int
var sent_items_count: int
var visible_sent_items_count: int


func _ready() -> void:
	mailor = UtilityTools.get_parent_of_type(self, Mailor)
	if mailor == null:
		printerr("Can't find parent Mailor node")
		return
	mailor.items_count_changed.connect(_on_items_count_changed)


func _on_items_count_changed() -> void:
	if folder_type == FolderType.INBOX:
		inbox_items_count = mailor.inbox_items.size()
		visible_inbox_items_count = mailor.visible_inbox_items.size()
		text = "(%s / %s)" % [visible_inbox_items_count, inbox_items_count]
	else:
		sent_items_count = mailor.sent_items.size()
		visible_sent_items_count = mailor.visible_sent_items.size()
		text = "(%s / %s)" % [visible_sent_items_count, sent_items_count]


func get_tooltip_icon() -> Texture2D:
	return null


func get_tooltip_header() -> String:
	return ""


func get_tooltip_body() -> String:
	var tooltip_body: String = "%s folder contains %s emails in total.\nCurrently showing %s emails."
	if folder_type == FolderType.INBOX:
		return tooltip_body % ["Inbox", inbox_items_count, visible_inbox_items_count]
	else:
		return tooltip_body % ["Sent", sent_items_count, visible_sent_items_count]
