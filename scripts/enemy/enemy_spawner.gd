@tool
class_name EnemySpawner
extends Node2D

## Configuration
@export var enemy_data: EnemyData:  ## The specific enemy type to spawn
	set(value):
		enemy_data = value
		queue_redraw()  # Update the visual representation
@export var spawn_on_ready: bool = true  ## Spawn enemy automatically when scene starts
@export var spawn_position_offset: Vector2 = Vector2.ZERO:  ## Offset from spawner's position
	set(value):
		spawn_position_offset = value
		queue_redraw()

## Editor Visualization
@export_group("Editor Preview")
@export var show_preview: bool = true  ## Show enemy preview in editor
@export var preview_color: Color = Color.RED  ## Color of the spawn indicator
@export var preview_radius: float = 16.0  ## Size of the spawn indicator

## Dynamic Spawning (optional - for runtime spawning)
@export_group("Dynamic Spawning")
@export var enable_dynamic_spawning: bool = false  ## Enable manual spawning with input
var spawn_input_action: String = "spawn_enemy"  ## Input action for manual spawning
@export var dynamic_enemy_pool: Array[EnemyData] = []  ## Pool of enemies for dynamic spawning

@onready var camera_2d: Camera2D = $"../Player/Camera2D" if has_node("../Player/Camera2D") else null

func _ready() -> void:
	# Only spawn enemies at runtime, not in editor
	if Engine.is_editor_hint():
		return
		
	if spawn_on_ready and enemy_data:
		spawn_enemy(enemy_data, global_position + spawn_position_offset)

func _draw() -> void:
	# Only draw preview in editor
	if not Engine.is_editor_hint() or not show_preview:
		return
	
	var spawn_pos = spawn_position_offset
	
	# Draw spawn indicator
	draw_circle(spawn_pos, preview_radius, preview_color * Color(1, 1, 1, 0.3))
	draw_arc(spawn_pos, preview_radius, 0, TAU, 32, preview_color, 2.0)
	
	# Draw cross to indicate position
	var cross_size = preview_radius * 0.5
	draw_line(spawn_pos + Vector2(-cross_size, 0), spawn_pos + Vector2(cross_size, 0), preview_color, 2.0)
	draw_line(spawn_pos + Vector2(0, -cross_size), spawn_pos + Vector2(0, cross_size), preview_color, 2.0)
	
	# Draw enemy name if available
	if enemy_data:
		var label_offset = Vector2(-30, -preview_radius - 10)
		draw_string(ThemeDB.fallback_font, spawn_pos + label_offset, enemy_data.enemy_name, HORIZONTAL_ALIGNMENT_CENTER, -1, 12, preview_color)

func _process(delta: float) -> void:
	# Skip input processing in editor
	if Engine.is_editor_hint():
		return
		
	if not enable_dynamic_spawning or dynamic_enemy_pool.is_empty():
		return
		
	if Input.is_action_just_pressed(spawn_input_action):
		var random_enemy = dynamic_enemy_pool.pick_random()
		var spawn_pos = camera_2d.get_global_mouse_position() if camera_2d else global_position
		spawn_enemy(random_enemy, spawn_pos)

func spawn_enemy(data: EnemyData, spawn_pos: Vector2) -> Enemy:
	# Don't spawn actual enemies in editor
	if Engine.is_editor_hint():
		return null
		
	if not data:
		push_error("EnemySpawner: No enemy data provided")
		return null
	
	var enemy_scene: Enemy = data.world_enemy_scene.instantiate()
	get_parent().call_deferred("add_child", enemy_scene)
	await get_tree().process_frame
	
	enemy_scene.global_position = spawn_pos
	enemy_scene.z_index = 100
	enemy_scene.setup(data)
	
	return enemy_scene
		
