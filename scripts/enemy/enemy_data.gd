class_name EnemyData
extends Resource

@export var enemy_name: String
@export var health: int = 10
@export var texture: Texture2D
@export var description: String = ""
@export var world_enemy_scene : PackedScene = preload("res://scenes/enemy.tscn")
