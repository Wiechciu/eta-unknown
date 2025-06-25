class_name EmailSyntaxHighlighter
extends SyntaxHighlighter


signal word_highlighted(text_edit: TextEdit, word: String, color: Color, line: int)


@export var keyword_groups: Dictionary[Color, Array] = {
	Color.GREEN: ["accept", "ok"],
	Color.RED: ["thank you", "correct"],
}
var last_highlighted_ranges: Dictionary = {} # line_number -> Array[Dictionary]



func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var result: Dictionary = {}
	var text: String = get_text_edit().get_line(line)
	
	var matches: Array[Dictionary] = []
	var occupied_ranges: Array[Dictionary] = []
	
	for color: Color in keyword_groups.keys():
		for phrase: String in keyword_groups[color]:
			var escaped_phrase: String = _escape_regex(phrase)
			
			# Use \b boundaries only for alphanumeric phrases
			var is_word_like: bool = _is_word_boundary_safe(phrase)
			var pattern: String = "(?i)" + ("\\b" + escaped_phrase + "\\b" if is_word_like else escaped_phrase)
			
			var regex: RegEx = RegEx.new()
			var compile_result: Error = regex.compile(pattern)
			
			if compile_result != OK:
				push_warning("Failed to compile regex for phrase: " + phrase)
				continue
			
			for regex_match: RegExMatch in regex.search_all(text):
				var start_idx: int = regex_match.get_start()
				var end_idx: int = regex_match.get_end()
				
				# Check for overlap with previously matched ranges
				var overlaps: bool = false
				for r: Dictionary in occupied_ranges:
					if not (end_idx <= r["start"] or start_idx >= r["end"]):
						overlaps = true
						break
				
				if overlaps:
					continue
				
				matches.append({
					"start": start_idx,
					"end": end_idx,
					"color": color
				})
				occupied_ranges.append({
					"start": start_idx,
					"end": end_idx
				})
	
	# Sort by start index to ensure deterministic coloring
	matches.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a["start"] < b["start"])
	
	for dict: Dictionary in matches:
		result[dict["start"]] = { "color": dict["color"] }
		result[dict["end"]] = {} # Reset color
	
	check_new_highlights(matches, line)
	return result


func _escape_regex(text: String) -> String:
	var special_chars: Array[String] = ['\\', '.', '+', '*', '?', '[', ']', '(', ')', '{', '}', '^', '$', '|']
	for special_char: String in special_chars:
		text = text.replace(special_char, "\\" + special_char)
	return text


func _is_word_boundary_safe(text: String) -> bool:
	for i: int in text.length():
		var c: String = text[i]
		if not ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or c == '_' or c == ' '):
			return false
	return true


func add_keyword_group(color: Color, keyword_group: Array) -> void:
	if keyword_groups.has(color):
		keyword_groups[color].append_array(keyword_group)
	else:
		keyword_groups[color] = keyword_group


func clear_keyword_groups() -> void:
	keyword_groups.clear()


func check_new_highlights(matches: Array[Dictionary], line: int) -> void:
	var old_ranges: Array[Dictionary] = last_highlighted_ranges.get(line, [] as Array[Dictionary])

	for match: Dictionary in matches:
		var start_idx: int = match["start"]
		var end_idx: int = match["end"]
		var color: Color = match["color"]

		var is_new: bool = true
		for old: Dictionary in old_ranges:
			if old["start"] == start_idx and old["end"] == end_idx:
				is_new = false
				break

		if is_new:
			var text: String = get_text_edit().get_line(line)
			var word: String = text.substr(start_idx, end_idx - start_idx)
			word_highlighted.emit(get_text_edit(), word, color, line)

	# Update the cache for this specific line
	last_highlighted_ranges[line] = matches.duplicate(true)
