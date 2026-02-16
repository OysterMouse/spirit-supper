extends Node2D

var item_sword: ToolData = preload("res://resources/tools/sword.tres")
var item_axe: ToolData = preload("res://resources/tools/axe.tres")

func _ready() -> void:
	
	var sword : GameItem = item_sword.world_item_scene.instantiate()
	sword.setup(item_sword)
	sword.global_position = Vector2(-30, -50)
	sword.z_index = 100
	add_child(sword)
	
	var axe: GameItem = item_axe.world_item_scene.instantiate()
	axe.setup(item_axe)
	axe.global_position = Vector2(600, -175)
	axe.z_index = 100
	add_child(axe)
