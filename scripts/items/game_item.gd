class_name GameItem
extends Node2D

var data : ItemData

func _ready() -> void:
	z_index = 100

func setup(_data : ItemData):
	data = _data
	$Item.texture = data.texture

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.pickup_item(data)
		queue_free()
