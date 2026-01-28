extends Node2D

var item_orange : ItemData = preload("res://resources/items/orange.tres")
var item_banana : ItemData = preload("res://resources/items/banana.tres")

func _ready() -> void:
	var orange : GameItem = item_orange.world_item_scene.instantiate()
	orange.setup(item_orange)
	orange.global_position = Vector2(120, 120)
	orange.z_index = 1
	add_child(orange)
	
	var banana : GameItem = item_banana.world_item_scene.instantiate()
	banana.setup(item_banana)
	banana.global_position = Vector2(220, 120)
	banana.z_index = 1
	add_child(banana)
