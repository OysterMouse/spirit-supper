extends State

@export var death_duration: float = 1.0

var death_timer: float = 0.0
var cleanup_done: bool = false

func enter() -> void:
	var enemy: Enemy = parent as Enemy
	#animation_name = enemy.data.death_anim
	super()  # Just travel to animation - blend position updates automatically
	
	# Stop all movement
	enemy.velocity = Vector2.ZERO
	
	# Disable collisions
	enemy.collision_shape_2d.set_deferred("disabled", true)
	enemy.hurt_collision_shape_2d.set_deferred("disabled", true)
	
	death_timer = 0.0
	cleanup_done = false

func process_physics(delta: float) -> State:
	var enemy: Enemy = parent as Enemy
	
	death_timer += delta
	
	# Ensure enemy stays still
	enemy.velocity = Vector2.ZERO
	
	# Queue free after death animation finishes
	if death_timer >= death_duration and not cleanup_done:
		cleanup_done = true
		enemy.queue_free()
	
	return null
