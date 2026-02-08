class_name Enemy
extends CharacterBody2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurt_collision_shape_2d: CollisionShape2D = $HurtComponent/CollisionShape2D
@onready var state_machine: Node = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var animation_tree: AnimationTree = $AnimationTree

@export var hit_state: State
@export var death_state: State

var player: Player
var data : EnemyData
var playback : AnimationNodeStateMachinePlayback
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.RIGHT  # Default facing down
var hit_cooldown_timer: float = 0.0  # Invulnerability timer
var is_super_armored: bool = false  # Can't be interrupted when true

func _ready() -> void:
	# Find the player in the scene
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("ERROR: Player not found!")
	
	# Initialize animation playback
	animation_tree.active = true
	playback = animation_tree.get("parameters/playback")
	
	# Connect signals
	hurt_component.damage_received.connect(_on_damage_received)
	
	# Setup collision shapes if data is already set
	if data:
		_setup_collision_shapes()
		init_state_machine()

func setup(_data: EnemyData) -> void:
	# Duplicate the resource so each enemy has its own stats
	data = _data.duplicate()
	animated_sprite.sprite_frames = _data.sprite_frames
	
	# Start playing animations
	#animated_sprite.play(data.idle_anim)
	
	# Setup collision shapes if _ready has already been called
	if collision_shape_2d:
		_setup_collision_shapes()
	init_state_machine()

func init_state_machine() -> void:
	state_machine.init(self, playback, null)

func _setup_collision_shapes() -> void:
	# Setup main collision shape
	var body_shape = RectangleShape2D.new()
	body_shape.size = data.collision_shape_size
	collision_shape_2d.shape = body_shape
	collision_shape_2d.position = data.collision_shape_offset
	
	# Setup hurtbox collision shape
	var hurt_shape = RectangleShape2D.new()
	hurt_shape.size = data.hurtbox_shape_size
	hurt_collision_shape_2d.shape = hurt_shape
	hurt_collision_shape_2d.position = data.hurtbox_shape_offset

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		last_direction = direction
	
	# Update invulnerability timer
	if hit_cooldown_timer > 0:
		hit_cooldown_timer -= delta
	
	# Update blend positions continuously like player does
	update_animation_params()
	
	if state_machine:
		state_machine.process_physics(delta)
		move_and_slide()
	
func _on_damage_received(amount: int, tool_type: DataTypes.Tools) -> void:
	# Check invulnerability first - don't take any damage if invulnerable
	if hit_cooldown_timer > 0:
		print("Invulnerable")
		return  # Still invulnerable, ignore damage completely
	
	# Apply damage
	data.health -= amount
	
	if data.health <= 0:
		# Transition to death state
		if death_state:
			print("hit and dead")
			state_machine.change_state(death_state)
	else:
		# Only stun if not super armored (invulnerability already checked above)
		if hit_state and not is_super_armored:
			state_machine.change_state(hit_state)
			print("hit")
		# With super armor: takes damage but doesn't get stunned

func update_animation_params():
	# Check if enemy data is loaded
	if not data:
		return
	# Use last_direction for blend position (updated when moving)
	if last_direction == Vector2.ZERO:
		return
	if not data.attack_anim:
		return
	animation_tree["parameters/" + data.idle_anim + "/blend_position"] = last_direction
	animation_tree["parameters/" + data.walk_anim + "/blend_position"] = last_direction
	animation_tree["parameters/" + data.hit_anim + "/blend_position"] = last_direction
	animation_tree["parameters/" + data.death_anim + "/blend_position"] = last_direction
	animation_tree["parameters/" + data.attack_anim + "/blend_position"] = last_direction
