extends Label


enum FolderType {
	INBOX,
	SENT,
}


@export var folder_type: FolderType
var mailor: Mailor
var inbox_items_count: int
var unread_inbox_items_count: int
var sent_items_count: int

func _ready() -> void:
	mailor = UtilityTools.get_parent_of_type(self, Mailor)
	if mailor == null:
		printerr("Can't find parent Mailor node")
		return
	mailor.items_count_changed.connect(_on_items_count_changed)


func _on_items_count_changed() -> void:
	if folder_type == FolderType.INBOX:
		inbox_items_count = mailor.inbox_items.size()
		unread_inbox_items_count = mailor.unread_inbox_items.size()
		text = "(%s | %s)" % [inbox_items_count, unread_inbox_items_count]
	else:
		sent_items_count = mailor.sent_items.size()
		text = "(%s)" % [sent_items_count]


func get_tooltip_icon() -> Texture2D:
	return null


func get_tooltip_header() -> String:
	return ""


func get_tooltip_body() -> String:
	if folder_type == FolderType.INBOX:
		return "Inbox folder contains %s emails,\nof which %s are unread." % [inbox_items_count, unread_inbox_items_count]
	else:
		return "Sent folder contains %s emails." % [sent_items_count]
