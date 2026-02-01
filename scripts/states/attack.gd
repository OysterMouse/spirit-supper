extends State

@export var idle_state: State
@export var move_state: State
@export var combo_window: float = 0.3

var is_using: bool
var combo_stage: int = 1
var input_pressed: bool = false
var current_attack: String = "Attack_1"  # Track which attack is playing

func enter() -> void:
	super()
	is_using = true
	combo_stage = 1
	input_pressed = false
	current_attack = "Attack_1"  # Reset for new combo
	# Set blend position to last direction
	playback.travel("Attack_1")

func exit() -> void:
	combo_stage = 1
	input_pressed = false

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("use"):
		input_pressed = true
	return null

func process_physics(delta: float) -> State:
	# Set blend position based on last direction
	parent.animations["parameters/Attack_1/blend_position"] = parent.last_direction
	parent.animations["parameters/Attack_2/blend_position"] = parent.last_direction
	
	# Lock player in place during attack
	parent.velocity = Vector2.ZERO
	parent.move_and_slide()
	
	if is_using == false:
		return move_state
	return null

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	# Only process if it's the current attack we're expecting
	if current_attack == "Attack_1" and "attack" in anim_name and input_pressed:
		combo_stage = 2
		input_pressed = false
		current_attack = "Attack_2"
		playback.travel("Attack_2")
	elif current_attack == "Attack_2" and "attack" in anim_name:
		is_using = false
	elif current_attack == "Attack_1" and "attack" in anim_name:
		is_using = false
