class_name LanguageButton
extends OptionButton


func _ready() -> void:
	var locales: PackedStringArray = TranslationServer.get_loaded_locales()
	for locale: String in locales:
		add_item(TranslationServer.get_language_name(locale).to_upper())


func _on_item_selected(index: int) -> void:
	update_language(index)


func get_item_index_by_text(text_to_search: String) -> int:
	for index: int in item_count:
		if get_item_text(index) == text_to_search:
			return index
	return -1


func update_language(index: int) -> void:
	if selected != index:
		select(index)
	var locale: String = TranslationServer.get_loaded_locales()[index]
	TranslationServer.set_locale(locale)


func select_default_language() -> void:
	var current_locale: String = OS.get_locale_language()
	var current_locale_name: String = TranslationServer.get_language_name(current_locale).to_upper()
	update_language(get_item_index_by_text(current_locale_name))
