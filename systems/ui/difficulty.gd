class_name DifficultyButton
extends OptionButton


func _ready() -> void:
	var counter: int = 0
	for difficulty_string: String in GameManager.Difficulty.keys():
		add_item("DIFFICULTY_NAME_" + difficulty_string.to_upper())
		set_item_tooltip(counter, "DIFFICULTY_DESCRIPTION_" + difficulty_string.to_upper())
		counter += 1


func _on_item_selected(index: int) -> void:
	update_difficulty(index)


func update_difficulty(index: int) -> void:
	if selected != index:
		select(index)
	GameManager.change_difficulty(index)


func select_default_difficulty() -> void:
	update_difficulty(GameManager.Difficulty.MEDIUM)
