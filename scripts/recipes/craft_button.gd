extends Button

@onready var label: Label = $Label

func set_craftable(d) -> void:
	disabled = !d
	
	var text_color = Color.WHITE
	
	if disabled:
		text_color = Color.RED
	
	label.add_theme_color_override("font_color", text_color)
