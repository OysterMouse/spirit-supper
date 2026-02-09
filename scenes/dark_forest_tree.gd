extends Sprite2D

@export var max_health: int = 30
@export var logs_to_drop: int = randi_range(2, 5)
@export var health_per_hit: int = 10

var current_health: int
var log_item: ItemData = preload("res://resources/items/log.tres")
var hurt_component: HurtComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	hurt_component = $HurtComponent
	
	if hurt_component:
		hurt_component.damage_received.connect(_on_damage_received)
	
func _on_damage_received(amount: int, tool_type: DataTypes.Tools) -> void:
	if tool_type != DataTypes.Tools.AXE:
		return
	
	current_health -= amount
	
	if current_health <= 0:
		_destroy_tree()

func _destroy_tree() -> void:
	for i in range(logs_to_drop):
		_spawn_log()
		
	queue_free()

func _spawn_log() -> void:
	var game_item: GameItem = log_item.world_item_scene.instantiate()
	game_item.setup(log_item)
	game_item.scale = Vector2(0.5, 0.5)
	game_item.global_position = global_position
	
	# Apply scatter velocity
	var angle = randf() * TAU
	game_item.velocity = Vector2.RIGHT.rotated(angle) * randf_range(50, 150)
	game_item.pickup_enabled = false  # Don't pick up while scattering
	
	get_parent().call_deferred("add_child", game_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
