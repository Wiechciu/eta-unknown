extends OptionButton


func _ready() -> void:
	var locales: PackedStringArray = TranslationServer.get_loaded_locales()
	for locale: String in locales:
		add_item(TranslationServer.get_language_name(locale).to_upper())
	
	var current_locale: String = OS.get_locale_language()
	var current_locale_name: String = TranslationServer.get_language_name(current_locale).to_upper()
	select(get_item_index_by_text(current_locale_name))


func _on_item_selected(index: int) -> void:
	var locale: String = TranslationServer.get_loaded_locales()[index]
	TranslationServer.set_locale(locale)


func get_item_index_by_text(text: String) -> int:
	for index: int in item_count:
		if get_item_text(index) == text:
			return index
	return -1
