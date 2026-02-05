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
		#_setup_collision_shapes()
		init_state_machine()


func setup(_data: EnemyData) -> void:
	# Duplicate the resource so each enemy has its own stats
	data = _data.duplicate()
	animated_sprite.sprite_frames = _data.sprite_frames
	
	# Setup collision shapes if _ready has already been called
	#if collision_shape_2d:
		#_setup_collision_shapes()
	init_state_machine()

func init_state_machine() -> void:
	state_machine.init(self, playback, null)

#func _setup_collision_shapes() -> void:
	#var texture_size = data.texture.get_size()
	#var shape = RectangleShape2D.new()
	#shape.size = texture_size
	#collision_shape_2d.shape = shape
	#hurt_collision_shape_2d.shape = shape
	#z_index = 100

func _physics_process(delta: float) -> void:
	if state_machine:
		state_machine.process_physics(delta)
	#follow_player()
	move_and_slide()

func _on_damage_received(amount: int, tool_type: DataTypes.Tools) -> void:
	data.health -= amount
	playback.travel(data.hit_anim)
	
	if data.health <= 0:
		playback.travel(data.death_anim)
		await get_tree().create_timer(0.5).timeout
		queue_free()
	#playback.travel("hit")
	#await get_tree().create_timer(0.15).timeout
	#playback.travel("Start")
	#
	#if data.health <= 0:
		#queue_free()

#func follow_player() -> void:
	#if not data:
		#return
	#if not data.follow_player:
		#return
	#if not player:
		#return
	#
	#var direction = (player.position - position).normalized()
	#if position.distance_to(player.position) < data.range:
		#velocity = direction * data.speed
	#else:
		#velocity = Vector2.ZERO
