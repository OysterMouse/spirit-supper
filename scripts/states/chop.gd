extends State

func enter() -> void:
	super()
	print("Chopping")
	parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
