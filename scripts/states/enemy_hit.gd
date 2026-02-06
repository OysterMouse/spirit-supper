extends State

@export var idle_state: State
@export var hit_duration: float = 0.3

var hit_timer: float = 0.0

func enter() -> void:
	var enemy: Enemy = parent as Enemy
	#animation_name = enemy.data.hit_anim
	super()  # Just travel to animation - blend position updates automatically
	
	# Stop movement during hit
	enemy.velocity = Vector2.ZERO
	hit_timer = 0.0

func process_physics(delta: float) -> State:
	var enemy: Enemy = parent as Enemy
	
	hit_timer += delta
	
	# Stop movement during hit
	enemy.velocity = Vector2.ZERO
	
	# Return to idle after hit duration
	if hit_timer >= hit_duration:
		return idle_state
	
	return null

func exit() -> void:
	hit_timer = 0.0
