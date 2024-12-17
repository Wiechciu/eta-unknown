extends Button


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	_on_visibility_changed()


func _on_visibility_changed() -> void:
	disabled = not SaveManager.is_game_loaded
