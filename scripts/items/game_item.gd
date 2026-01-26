class_name GameItem
extends Node2D

var data : ItemData

func setup(_data : ItemData):
	data = _data
	$Item.texture = data.texture

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.pickup_item(data)
		print("Picked up: ", data.item_name)
		queue_free()
