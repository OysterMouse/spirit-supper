class_name HitComponent
extends Area2D

var tool_type : DataTypes.Tools
var damage: int
var tool_name: String = ""

signal hit_hurtbox(hurtbox: HurtComponent)

func _ready() -> void:
	#area_entered.connect(_on_area_entered)
	monitoring = false  # Start disabled

func set_tool_data(tool_data: ToolData) -> void:
	damage = tool_data.damage
	tool_type = tool_data.tool_type
	tool_name = tool_data.item_name

func enable_and_check() -> void:
	monitoring = true
	# Check for already overlapping areas when enabling
	for area in get_overlapping_areas():
		if area is HurtComponent:
			area.take_damage(damage, tool_type)
			hit_hurtbox.emit(area)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtComponent:
		area.take_damage(damage, tool_type)
		hit_hurtbox.emit(area)
		print("Hit with: ", tool_name, " (", DataTypes.Tools.keys()[tool_type], ") for ", damage, " damage")
