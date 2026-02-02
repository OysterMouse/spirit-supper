extends State
@onready var hit_component: HitComponent = $"../../HitComponent"

@export var move_state: State

var is_finished: bool = false

func exit() -> void:
	if hit_component:
		hit_component.monitoring = false

func enter() -> void:
	super()
	is_finished = false
	
	# Set tool data from player's cached tool
	if parent.equipped_tool_data and hit_component:
		hit_component.set_tool_data(parent.equipped_tool_data)
	
	# Enable monitoring and check for overlaps
	if hit_component:
		hit_component.enable_and_check()
	
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
		
