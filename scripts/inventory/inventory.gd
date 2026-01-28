class_name Inventory
extends Node

@export var size : int = 15

var slots : Array[InventorySlot] = []

signal changed

func _ready() -> void:
	_resize_inventory()

func _resize_inventory() -> void:
	var old_size = slots.size()
	if old_size < size:
		# Expand: add null slots
		for i in range(size - old_size):
			slots.append(null)
	elif old_size > size:
		# Shrink: remove excess slots (keep items if possible)
		slots.resize(size)

func add_item(item: ItemData, amount : int = 1):
	var remaining : int = amount
	# Stack first
	for slot in slots:
		if slot and slot.item == item and not slot.is_full():
			var addable : int = min(slot.remaining_space(), remaining)
			slot.quantity += addable
			remaining -= addable
			if remaining == 0:
				changed.emit()
				return 0

	# Find empty slot
	for i in slots.size():
		if slots[i] == null:
			var new_slot := InventorySlot.new()
			new_slot.item = item
			new_slot.quantity = min(item.stack_size, remaining)
			slots[i] = new_slot
			remaining -= new_slot.quantity
			if remaining == 0:
				changed.emit()
				return 0
	
	changed.emit()
	return remaining

func swap_slots(a: int, b: int):
	var slot_a = slots[a]
	var slot_b = slots[b]

	# If either is empty → normal swap
	if slot_a == null or slot_b == null:
		slots[a] = slot_b
		slots[b] = slot_a
		changed.emit()
		return

	# Same item → merge stacks
	if slot_a.item == slot_b.item:
		var transfer : int = min(
			slot_b.remaining_space(),
			slot_a.quantity
		)

		slot_b.quantity += transfer
		slot_a.quantity -= transfer

		if slot_a.quantity <= 0:
			slots[a] = null

		changed.emit()
		return

	# Different items → swap
	slots[a] = slot_b
	slots[b] = slot_a
	changed.emit()
