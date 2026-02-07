extends State

@export var idle_state: State
@export var attack_state: State

var attack_cooldown_timer: float = 0.0

func enter() -> void:
	var enemy: Enemy = parent as Enemy
	#animation_name = enemy.data.walk_anim
	super()

func process_physics(delta: float) -> State:
	var enemy: Enemy = parent as Enemy
	
	if attack_cooldown_timer > 0:
		attack_cooldown_timer -= delta

	if not enemy.player:
		return idle_state
	
	var distance = enemy.position.distance_to(enemy.player.position)
	
	# Too far, return to idle
	if distance > enemy.data.detection_range:
		attack_cooldown_timer = 0.0
		return idle_state
	
	# Close enough to attack
	if enemy.data.can_attack and attack_state and distance < enemy.data.attack_range and attack_cooldown_timer <= 0:
		return attack_state
	
	# Chase player
	var direction = (enemy.player.position - enemy.position).normalized()
	enemy.velocity = direction * enemy.data.speed
	enemy.direction = direction
	
	# Track last direction (blend position updates automatically)
	if direction.length() > 0.1:
		enemy.last_direction = direction
	
	return null
