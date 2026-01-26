extends State

@export var move_state: State
@export var attack_state: State

func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	if input_component.get_input_direction():
		return move_state
	if Input.is_action_just_pressed("use_tool"):
		return attack_state
	return null

func process_physics(delta: float) -> State:
	return null