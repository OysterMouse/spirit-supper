extends State

@export var chase_state: State

var player : Player
func enter() -> void:
	var enemy: Enemy = parent as Enemy
	animation_name = enemy.data.idle_anim
	player = get_tree().get_first_node_in_group("player")
	super()

func process_physics(delta: float) -> State:
	var enemy: Enemy = parent as Enemy
	enemy.velocity = Vector2.ZERO
	
	if player:
		var distance = enemy.position.distance_to(player.position)
		if distance < enemy.data.detection_range:
			return chase_state
	
	return null
