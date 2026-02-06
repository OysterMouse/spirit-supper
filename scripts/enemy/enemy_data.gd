class_name EnemyData
extends Resource

@export var enemy_name: String
@export var health: int = 10
@export var sprite_frames: SpriteFrames
@export var speed: float
@export var range: float
@export var description: String = ""
@export var world_enemy_scene : PackedScene = preload("res://scenes/enemy.tscn")
@export var follow_player: bool

# Animation Configuration
@export_group("Animations")
@export var idle_anim: String = "Idle"
@export var walk_anim: String = "Walk"
@export var attack_anim: String = "Attack"
@export var hit_anim: String = "Hit"
@export var death_anim: String = "Death"

# Behavior Configuration
@export_group("Behaviors")
@export var attack_range: float = 30.0
@export var detection_range: float = 100.0
@export var attack_cooldown: float = 1.0
@export var can_attack: bool = false
@export var attack_damage: int = 5

# Collision Configuration
@export_group("Collision")
@export var collision_shape_size: Vector2 = Vector2(32, 32)
@export var collision_shape_offset: Vector2 = Vector2.ZERO
@export var hurtbox_shape_size: Vector2 = Vector2(32, 32)
@export var hurtbox_shape_offset: Vector2 = Vector2.ZERO
