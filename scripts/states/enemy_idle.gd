extends State

@export var chase_state: State

func enter() -> void:
	var enemy: Enemy = parent as Enemy
	animation_name = enemy.data.idle_anim
	super()  # Just travel to animation - blend position updates automatically

func process_physics(delta: float) -> State:
	var enemy: Enemy = parent as Enemy
	
	# Stand still
	enemy.velocity = Vector2.ZERO
	enemy.direction = Vector2.ZERO
	
	# Check if player is in detection range
	if enemy.player:
		var distance = enemy.position.distance_to(enemy.player.position)
		if distance < enemy.data.detection_range:
			return chase_state
	
	return null
