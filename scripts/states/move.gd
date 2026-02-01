extends State

@export var idle_state: State
@export var attack_state: State

func enter() -> void:
	super()

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	parent.direction = input_component.get_input_direction()

	parent.velocity = parent.direction * parent.move_speed
	parent.move_and_slide()

	# Track last facing direction
	if parent.direction != Vector2.ZERO:
		parent.last_direction = parent.direction

	if parent.velocity == Vector2.ZERO:
		return idle_state
	#if Input.is_action_just_pressed("use_tool"):
		#return attack_state
	return null
