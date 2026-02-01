extends State

@export var move_state: State
var is_finished: bool = false

func enter() -> void:
	super()
	is_finished = false
	print("Chopping")
	parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	if is_finished:
		return move_state
	return null

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "chop" in anim_name:
		is_finished = true
		
