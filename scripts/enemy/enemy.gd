class_name Enemy
extends CharacterBody2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurt_collision_shape_2d: CollisionShape2D = $HurtComponent/CollisionShape2D
@onready var state_machine: Node = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

var player: Player
var data : EnemyData
var playback : AnimationNodeStateMachinePlayback
@onready var animation_tree: AnimationTree = $AnimationTree

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
	animated_sprite.play(data.idle_anim)
	
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
	if state_machine:
		state_machine.process_physics(delta)
	move_and_slide()

func _on_damage_received(amount: int, tool_type: DataTypes.Tools) -> void:
	data.health -= amount
	playback.travel(data.hit_anim)
	if data.health <= 0:
		playback.travel(data.death_anim)
		await get_tree().create_timer(1).timeout
		queue_free()
	
	if data.health <= 0:
		queue_free()
