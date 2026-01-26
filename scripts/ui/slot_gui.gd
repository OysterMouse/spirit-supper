class_name SlotGUI
extends Panel

@onready var background: Sprite2D = $Background
@onready var icon: Sprite2D = $CenterContainer/Panel/Item
@onready var quantity: Label = $CenterContainer/Panel/Quantity

var slot_index : int
var inventory : InventoryGUI

func _get_drag_data(at_position: Vector2):
	
	if not icon.visible:
		return null
	
	var drag_preview = TextureRect.new()
	drag_preview.custom_minimum_size = Vector2(24, 24)
	drag_preview.texture = icon.texture
	set_drag_preview(drag_preview)
	
	var data = {
		"from_index": slot_index
	}
	return data

func _can_drop_data(at_position: Vector2, data) -> bool:
	return data is Dictionary and data.has("from_index")

func _drop_data(at_position: Vector2, data) -> void:
	var from_index = data["from_index"]
	var to_index = slot_index
	
	inventory.request_swap(from_index, to_index)

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("CLICKED SLOT", slot_index)
