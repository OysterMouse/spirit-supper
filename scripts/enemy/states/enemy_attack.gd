extends State

@export var idle_state: State
var is_attacking: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func enter() -> void:
	var enemy: Enemy = parent as Enemy
	enemy.velocity = Vector2.ZERO
	is_attacking = true
	
	# Enable super armor if configured
	if enemy.data.super_armor_during_attack:
		enemy.is_super_armored = true
	
	super()

func process_physics(delta: float) -> State:
	var enemy: Enemy = parent as Enemy

	# Update direction to face the player during attack
	if enemy.player:
		var direction = (enemy.player.position - enemy.position).normalized()
		enemy.last_direction = direction
	
	if is_attacking == false:
		return idle_state
	return null

func exit() -> void:
	var chase_state = get_node("../Chase")
	if chase_state:
		chase_state.attack_cooldown_timer = parent.data.attack_cooldown
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name:
		is_attacking = false
