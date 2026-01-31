class_name Hotbar
extends MarginContainer

@export var inventory: Inventory
@export var hotbar_slots: int = 9

@onready var slots_container: HBoxContainer = $HBoxContainer

var slot_scene: PackedScene = preload("res://scenes/slot_gui.tscn")
var slot_guis: Array[SlotGUI] = []
var selected_index: int = 0

func _ready() -> void:
	_build_slots()
	if inventory:
		inventory.changed.connect(_on_inventory_changed)
		_on_inventory_changed()
	_update_selection()

func _build_slots():
	# Clear any existing children
	for child in slots_container.get_children():
		child.queue_free()
	
	# Create hotbar slot GUIs
	for i in range(hotbar_slots):
		var slot: SlotGUI = slot_scene.instantiate()
		slot.slot_index = i
		slot.inventory = self  # This will cause the error - needs to be InventoryGUI compatible
		slots_container.add_child(slot)
		slot_guis.append(slot)

func _on_inventory_changed():
	# Update hotbar visuals from first N inventory slots
	for i in range(hotbar_slots):
		if i < inventory.slots.size() and inventory.slots[i]:
			var slot_data = inventory.slots[i]
			slot_guis[i].icon.texture = slot_data.item.texture
			slot_guis[i].icon.visible = true
			if slot_data.quantity > 1:
				slot_guis[i].quantity.text = str(slot_data.quantity)
				slot_guis[i].quantity.visible = true
			else:
				slot_guis[i].quantity.visible = false
		else:
			slot_guis[i].icon.visible = false
			slot_guis[i].quantity.visible = false

func _input(event: InputEvent):
	# Number keys 1-9 to select hotbar slots
	if event.is_action_pressed("hotbar_1"):
		select_slot(0)
	elif event.is_action_pressed("hotbar_2"):
		select_slot(1)
	elif event.is_action_pressed("hotbar_3"):
		select_slot(2)
	elif event.is_action_pressed("hotbar_4"):
		select_slot(3)
	elif event.is_action_pressed("hotbar_5"):
		select_slot(4)
	elif event.is_action_pressed("hotbar_6"):
		select_slot(5)
	elif event.is_action_pressed("hotbar_7"):
		select_slot(6)
	elif event.is_action_pressed("hotbar_8"):
		select_slot(7)
	elif event.is_action_pressed("hotbar_9"):
		select_slot(8)

func select_slot(index: int):
	if index >= 0 and index < hotbar_slots:
		selected_index = index
		_update_selection()

func _update_selection():
	# Visual feedback for selected slot
	for i in range(slot_guis.size()):
		if i == selected_index:
			slot_guis[i].modulate = Color.WHITE
		else:
			slot_guis[i].modulate = Color(0.7, 0.7, 0.7, 1.0)

func get_selected_item() -> ItemData:
	if selected_index < inventory.slots.size() and inventory.slots[selected_index]:
		return inventory.slots[selected_index].item
	return null

func get_selected_tool() -> ToolData:
	var item = get_selected_item()
	if item is ToolData:
		get_parent().current_tool = item.tool_type
		print("Equipped tool type:", get_parent().current_tool)
		return item
	return null

# Required for SlotGUI compatibility
func request_swap(from_index: int, to_index: int):
	if inventory:
		inventory.swap_slots(from_index, to_index)
