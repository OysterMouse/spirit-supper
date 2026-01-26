extends MarginContainer

@onready var tool_axe: Button = $HBoxContainer/ToolAxe
@onready var tool_hoe: Button = $HBoxContainer/ToolHoe
@onready var tool_sword: Button = $HBoxContainer/ToolSword

func _ready() -> void:
	visible = true

func _on_tool_axe_pressed() -> void:
	print("Axe selected")

func _on_tool_sword_pressed() -> void:
	print("Sword selected")

func _on_tool_hoe_pressed() -> void:
	print("Hoe selected")
