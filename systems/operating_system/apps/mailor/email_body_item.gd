class_name EmailBodyItem
extends RichTextLabel


var email: Email


@warning_ignore("shadowed_variable")
func initialize(email: Email, _is_read_only: bool) -> void:
	self.email = email
	self.text = email.body
