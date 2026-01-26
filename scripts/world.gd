extends Node2D

var item : ItemData = preload("res://resources/items/orange.tres")

func _ready() -> void:
	var orange : GameItem = item.world_item_scene.instantiate()
	orange.setup(item)
	orange.global_position = Vector2(120, 120)
	orange.z_index = 1
	add_child(orange)
	var orange2 : GameItem = item.world_item_scene.instantiate()
	orange2.setup(item)
	orange2.global_position = Vector2(220, 120)
	orange2.z_index = 1
	add_child(orange2)
	var orange3 : GameItem = item.world_item_scene.instantiate()
	orange3.setup(item)
	orange3.global_position = Vector2(120, 220)
	orange3.z_index = 1
	add_child(orange3)
