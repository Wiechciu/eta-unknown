extends CheckButton


signal tooltip_retrigger


func _ready() -> void:
	button_pressed = true
	pressed.connect(tooltip_retrigger.emit)


func get_tooltip_icon() -> Texture2D:
	return null


func get_tooltip_header() -> String:
	return ""


func get_tooltip_body() -> String:
	return "Hide read emails and show only unread." if button_pressed else "Show all emails, both read and unread."
