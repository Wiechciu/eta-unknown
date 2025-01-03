extends StaticBody3D


@export var day_label: Label3D
@export var month_label: Label3D
@export var weekday_label: Label3D


func _ready() -> void:
	UtilityTools.assert_all_exported_properties(self)
	GlobalTimer.new_day_started.connect(update_calendar)
	register_interactable()


func update_calendar() -> void:
	day_label.text = "%d" % GlobalTimer.current_day
	month_label.text = GlobalTimer.current_month_genitive_string
	weekday_label.text = GlobalTimer.current_weekday_string


func register_interactable() -> void:
	var interactable: Interactable = UtilityTools.get_child_of_type(self, Interactable) as Interactable
	if interactable != null:
		interactable.interacted.connect(interact.unbind(1))


func interact() -> void:
	GlobalTimer.start_next_day_with_fade()
