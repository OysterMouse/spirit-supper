class_name Enemy
extends CharacterBody2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hurt_collision_shape_2d: CollisionShape2D = $HurtComponent/CollisionShape2D

var player: Player
var data : EnemyData

func _ready() -> void:
	# Find the player in the scene
	player = get_tree().get_first_node_in_group("player")
	if not player:
		print("ERROR: Player not found!")
	
	# Connect signals
	hurt_component.damage_received.connect(_on_damage_received)
	
	# Setup collision shapes if data is already set
	if data:
		_setup_collision_shapes()

func setup(_data: EnemyData) -> void:
	data = _data
	$Sprite.texture = _data.texture
	
	# Setup collision shapes if _ready has already been called
	if collision_shape_2d:
		_setup_collision_shapes()

func _setup_collision_shapes() -> void:
	var texture_size = data.texture.get_size()
	var shape = RectangleShape2D.new()
	shape.size = texture_size
	collision_shape_2d.shape = shape
	hurt_collision_shape_2d.shape = shape
	z_index = 100

func _physics_process(delta: float) -> void:
	follow_player()
	move_and_slide()

func _on_damage_received(amount: int, tool_type: DataTypes.Tools) -> void:
	data.health -= amount
	
	if data.health <= 0:
		queue_free()

func follow_player() -> void:
	if not data:
		return
	if not data.follow_player:
		return
	if not player:
		return
	
	var direction = (player.position - position).normalized()
	if position.distance_to(player.position) < data.range:
		velocity = direction * data.speed
	else:
		velocity = Vector2.ZERO
