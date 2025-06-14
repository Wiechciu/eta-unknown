class_name State
extends Resource


@export var state_name: String
@export_multiline var state_description: String
@export var state_icon: Texture2D
@export var initial_value: float = 100.0
@export var min_value: float = 0.0
@export var max_value: float = 100.0
@export var regeneration_per_hour: float
@export var regeneration_on_new_day: float
@export var positive_effect: bool = true
