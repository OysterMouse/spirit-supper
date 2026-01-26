class_name InventorySlot
extends Node

var item: ItemData
var quantity: int

func is_full() -> bool:
	return quantity >= item.stack_size

func remaining_space() -> int:
	return item.stack_size - quantity
