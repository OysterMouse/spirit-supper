class_name EnemySpawner
extends Node

@onready var camera_2d: Camera2D = $"../Player/Camera2D"
@export var enemies: Array[EnemyData] = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	for enemy in enemies:
		var random_enemy = enemies[0]
		var enemy_scene: Enemy = random_enemy.world_enemy_scene.instantiate()
		var mouse_pos: Vector2 = camera_2d.get_global_mouse_position()
		
		if Input.is_action_just_pressed("spawn_enemy"):
			get_parent().call_deferred("add_child", enemy_scene)
			await get_tree().process_frame
			
			enemy_scene.position = mouse_pos
			enemy_scene.z_index = 100
			enemy_scene.setup(random_enemy)
		
