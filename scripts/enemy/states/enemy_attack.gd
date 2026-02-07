extends State

@export var idle_state: State
var is_attacking: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func enter() -> void:
	parent.velocity = Vector2.ZERO
	is_attacking = true
	super()

func process_physics(delta: float) -> State:
	if is_attacking == false:
		return idle_state
	return null

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name:
		is_attacking = false
