class_name ItemData
extends Resource

@export var item_name: String
@export var texture: Texture2D
var world_item_scene: PackedScene = preload("res://scenes/game_item.tscn")
@export var description: String
@export var stack_size: int = 1
@export var is_tool: bool = false
