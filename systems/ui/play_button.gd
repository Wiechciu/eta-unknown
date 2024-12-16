extends Button


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	_on_visibility_changed()


func _on_visibility_changed() -> void:
	if SaveManager.is_game_loaded:
		disabled = false
	else:
		disabled = true
