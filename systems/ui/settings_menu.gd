extends PanelContainer


@export var tab_container: TabContainer

@export var reset_settings_button: Button

@export var language: LanguageButton
@export var difficulty: DifficultyButton
@export var autosave: AutosaveSettings
@export var master_volume: VolumeSlider
@export var music_volume: VolumeSlider
@export var ui_volume: VolumeSlider
@export var voice_volume: VolumeSlider
@export var environment_volume: VolumeSlider
@export var graphics_quality: OptionButton
@export var fullscreen: CheckButton
@export var controls_settings: ControlsSettings


var settings_folder: String = "user://"
var settings_file_name: String = "settings"
var settings_file_extension: String = ".cfg"


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	visibility_changed.connect(_on_visibility_changed)
	reset_settings_button.pressed.connect(load_default_settings)
	load_settings()


func _on_visibility_changed() -> void:
	if visible:
		tab_container.current_tab = 0
	
	if not visible and get_tree().root.is_node_ready():
		save_settings()


func save_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("header", "version", ProjectSettings.get_setting("application/config/version"))
	config.set_value("game", "language", language.selected)
	config.set_value("game", "difficulty", difficulty.selected)
	config.set_value("game", "autosave", autosave.value_bool)
	config.set_value("game", "autosave_interval", autosave.value_number)
	config.set_value("audio", "master_volume", master_volume.value)
	config.set_value("audio", "music_volume", music_volume.value)
	config.set_value("audio", "ui_volume", ui_volume.value)
	config.set_value("audio", "voice_volume", voice_volume.value)
	config.set_value("audio", "environment_volume", environment_volume.value)
	#config.set_value("video", "graphics_quality", graphics_quality.selected)
	config.set_value("video", "fullscreen", fullscreen.button_pressed)
	for action_name: String in InputMap.get_actions():
		if action_name.begins_with("ui"):
			continue
		var counter: int = 0
		for event: InputEvent in InputMap.action_get_events(action_name):
			if event is InputEventKey:
				config.set_value("controls", action_name + str(counter), event.physical_keycode)
				counter += 1
	config.save(settings_folder + settings_file_name + settings_file_extension)
	print("Settings saved to file: %s." % (settings_file_name + settings_file_extension))


func load_settings() -> void:
	var config: ConfigFile = ConfigFile.new()
	if config.load(settings_folder + settings_file_name + settings_file_extension) != OK:
		load_default_settings()
		return
	
	var settings_version: String = config.get_value("header", "version")
	var current_version: String = ProjectSettings.get_setting("application/config/version")
	if settings_version != current_version:
		load_default_settings()
		return
	
	language.update_language(config.get_value("game", "language") as int)
	difficulty.update_difficulty(config.get_value("game", "difficulty") as int)
	autosave.value_bool = config.get_value("game", "autosave") as bool
	autosave.value_number = config.get_value("game", "autosave_interval") as int
	master_volume.value = config.get_value("audio", "master_volume") as float
	music_volume.value = config.get_value("audio", "music_volume") as float
	ui_volume.value = config.get_value("audio", "ui_volume") as float
	voice_volume.value = config.get_value("audio", "voice_volume") as float
	environment_volume.value = config.get_value("audio", "environment_volume") as float
	#graphics_quality.select(config.get_value("video", "graphics_quality") as int)
	fullscreen.button_pressed = config.get_value("video", "fullscreen") as bool
	for action_name: String in InputMap.get_actions():
		if action_name.begins_with("ui"):
			continue
		InputMap.action_erase_events(action_name)
		for counter: int in 2:
			var keycode: Key = config.get_value("controls", action_name + str(counter), KEY_NONE)
			if keycode != KEY_NONE:
				var event: InputEventKey = InputEventKey.new()
				event.physical_keycode = keycode
				InputMap.action_add_event(action_name, event)
	controls_settings.refresh_container()
	print("Settings loaded from file: %s." % (settings_file_name + settings_file_extension))


func load_default_settings() -> void:
	language.select_default_language()
	difficulty.select_default_difficulty()
	autosave.value_bool = true
	autosave.value_number = 5
	master_volume.value = 0.8
	music_volume.value = 1.0
	ui_volume.value = 1.0
	voice_volume.value = 1.0
	environment_volume.value = 1.0
	#graphics_quality.select(0)
	fullscreen.button_pressed = false
	InputMap.load_from_project_settings()
	controls_settings.refresh_container()
	print("Default settings loaded.")
