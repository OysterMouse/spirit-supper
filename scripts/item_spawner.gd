@tool
extends Node2D

@export var possible_items: Array[ItemData]
@export var spawn_radius: float = 64.0
@export var spawn_on_ready: bool = true

# Editor helper: toggle in inspector to spawn one item (auto-resets)
@export var inspector_spawn: bool = false
var _last_inspector_spawn: bool = false

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		set_process(true)

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	if inspector_spawn and not _last_inspector_spawn:
		spawn_item()
		inspector_spawn = false
		extends Node2D

		@export var possible_items: Array[ItemData]
		@export var spawn_radius: float = 64.0
		@export var spawn_on_ready: bool = true

		func _ready() -> void:
			if spawn_on_ready:
				randomize()
				spawn_item()

		func spawn_item():
			if possible_items.is_empty():
				print("empty")
				return
    
			var item_data = possible_items.pick_random()
			var item_scene : GameItem = item_data.world_item_scene.instantiate()

			# Add instance to the active scene (deferred) and wait one frame so it's inside the tree
			var cs = get_tree().get_current_scene()
			if cs:
				cs.call_deferred("add_child", item_scene)
			else:
				get_tree().get_root().call_deferred("add_child", item_scene)

			await get_tree().process_frame

			# Position and configure the instance
			item_scene.position = position + random_offset()
			item_scene.z_index = 100

			item_scene.setup(item_data)
			if item_scene.has_node("Item"):
				var sprite = item_scene.get_node("Item")
				sprite.visible = true
				if sprite.scale == Vector2.ZERO:
					sprite.scale = Vector2.ONE
				sprite.z_index = 100

			item_scene.show()

			print("Parent:", item_scene.get_parent())
			print("Spawned:", item_data.item_name)
			print("At:", item_scene.position)

		func random_offset() -> Vector2:
			return Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius))
			sprite.z_index = 100
