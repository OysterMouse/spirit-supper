class_name InventoryGUI
extends Control

@export var inventory: Inventory
@onready var grid_container: GridContainer = $NinePatchRect/GridContainer

var slot_scene: PackedScene = preload("res://scenes/slot_gui.tscn")
var ui_slots: Array[Control] = []
var is_open: bool = false

func _ready():
	if inventory == null:
		push_error("InventoryGUI: inventory property is not set!")
		return
	_build_slots()
	inventory.changed.connect(refresh_inventory)
	refresh_inventory()
	close()

func _build_slots():
	for i in inventory.size:
		var slot_ui := slot_scene.instantiate()
		grid_container.add_child(slot_ui)
		
		slot_ui.slot_index = i
		slot_ui.inventory = self
		
		ui_slots.append(slot_ui)

func refresh_inventory():
	for i in inventory.size:
		var data_slot = inventory.slots[i]
		var ui_slot = ui_slots[i]

		var item: Sprite2D = ui_slot.get_node("CenterContainer/Panel/Item")
		var background : Sprite2D = ui_slot.get_node("Background")
		var qty := ui_slot.get_node("CenterContainer/Panel/Quantity")

		if data_slot == null:
			item.visible = false
			background.frame = 0
			qty.visible = false
		else:
			item.texture = data_slot.item.texture
			background.frame = 1
			item.visible = true

			if data_slot.quantity > 1:
				qty.text = str(data_slot.quantity)
				qty.visible = true
			else:
				qty.visible = false

func request_swap(from_index : int, to_index : int):
	if from_index == to_index:
		return
	
	inventory.swap_slots(from_index, to_index)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		if is_open:
			close()
		else:
			open()

func open() -> void:
	visible = true
	is_open = true

func close() -> void:
	visible = false
	is_open = false
