class_name ItemSpawner
extends Node

@export var items : Array[ItemData] = []
@onready var camera_2d: Camera2D = $"../Player/Camera2D"


func _process(delta: float) -> void:
	for item in items:
		var random_item = items.pick_random()
		var item_scene : GameItem = random_item.world_item_scene.instantiate()
		var mouse_pos : Vector2 = camera_2d.get_global_mouse_position()
		
		if Input.is_action_just_pressed("spawn"):
			
			get_parent().call_deferred("add_child", item_scene)
			await get_tree().process_frame
			
			item_scene.position = mouse_pos
			item_scene.z_index = 100
			item_scene.setup(random_item)
			#item_scene.show()
			
			print("Spawned:", random_item.item_name)
			print("At:", item_scene.position)
