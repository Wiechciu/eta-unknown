extends Node


const FADE_DURATION_RATIO: float = float(GlobalTimer.ONE_HOUR) / float(GlobalTimer.ONE_DAY)
const SUNRISE_TIME: int = 6 * GlobalTimer.ONE_HOUR
const SUNRISE_FADE_START_RATIO: float = float(SUNRISE_TIME) / float(GlobalTimer.ONE_DAY)
const SUNRISE_FADE_END_RATIO: float = SUNRISE_FADE_START_RATIO + FADE_DURATION_RATIO
const SUNSET_FADE_START_RATIO: float = SUNRISE_FADE_START_RATIO + 0.5 - FADE_DURATION_RATIO
const SUNSET_FADE_END_RATIO: float = SUNSET_FADE_START_RATIO + FADE_DURATION_RATIO
const MIN_SUN_ENERGY: float = 0.0
const MAX_SUN_ENERGY: float = 1.3
const MIN_ENVIRONMENT_ENERGY: float = 0.30
const MAX_ENVIRONMENT_ENERGY: float = 1.5

@export var sun: DirectionalLight3D
@export var world_environment: WorldEnvironment


func _ready() -> void:
	sun.rotation.y = deg_to_rad(140)
	sun.rotation.z = deg_to_rad(0)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var time_dict: Dictionary = GlobalTimer.time_dictionary
	var hours: float = time_dict["hour"]
	var minutes: float = time_dict["minute"]
	var seconds: float = time_dict["second"]
	var total_seconds: float = hours * 60 * 60 + minutes * 60 + seconds
	
	var day_ratio: float = total_seconds / GlobalTimer.ONE_DAY ## 0.0 is 00:00, 0.5 is 12:00 
	sun.rotation.x = fmod(PI + (day_ratio - SUNRISE_FADE_START_RATIO) * TAU, TAU)
	
	if day_ratio >= SUNRISE_FADE_START_RATIO and day_ratio < SUNRISE_FADE_END_RATIO:
		var ratio: float = (day_ratio - SUNRISE_FADE_START_RATIO) / (SUNRISE_FADE_END_RATIO - SUNRISE_FADE_START_RATIO)
		sun.light_energy = MIN_SUN_ENERGY + (MAX_SUN_ENERGY - MIN_SUN_ENERGY) * ratio
		world_environment.environment.background_energy_multiplier = MIN_ENVIRONMENT_ENERGY + (MAX_ENVIRONMENT_ENERGY - MIN_ENVIRONMENT_ENERGY) * ratio
	elif day_ratio >= SUNRISE_FADE_END_RATIO and day_ratio < SUNSET_FADE_START_RATIO:
		sun.light_energy = MAX_SUN_ENERGY
		world_environment.environment.background_energy_multiplier = MAX_ENVIRONMENT_ENERGY
	elif day_ratio >= SUNSET_FADE_START_RATIO and day_ratio < SUNSET_FADE_END_RATIO:
		var ratio: float = 1 - (day_ratio - SUNSET_FADE_START_RATIO) / (SUNSET_FADE_END_RATIO - SUNSET_FADE_START_RATIO)
		sun.light_energy = MIN_SUN_ENERGY + (MAX_SUN_ENERGY - MIN_SUN_ENERGY) * ratio
		world_environment.environment.background_energy_multiplier = MIN_ENVIRONMENT_ENERGY + (MAX_ENVIRONMENT_ENERGY - MIN_ENVIRONMENT_ENERGY) * ratio
	else:
		sun.light_energy = MIN_SUN_ENERGY
		world_environment.environment.background_energy_multiplier = MIN_ENVIRONMENT_ENERGY
	
	#if day_ratio >= SUNRISE_TIME_RATIO and day_ratio < SUNSET_FADE_START_RATIO:
		#light_energy = 1
	#elif day_ratio >= SUNSET_FADE_START_RATIO and day_ratio < SUNSET_TIME_RATIO:
		#light_energy = (day_ratio - SUNSET_FADE_START_RATIO) / FADE_DURATION_RATIO
	#elif day_ratio >= SUNSET_TIME_RATIO and day_ratio < SUNRISE_TIME_RATIO:
		#light_energy = 0
	#else:
		#light_energy = (day_ratio - SUNRISE_TIME_RATIO) / FADE_DURATION_RATIO
