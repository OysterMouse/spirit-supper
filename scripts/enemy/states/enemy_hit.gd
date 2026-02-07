extends State

@export var idle_state: State
@export var hit_duration: float = 0.3

var hit_timer: float = 0.0

func enter() -> void:
	var enemy: Enemy = parent as Enemy
	
	# Stop movement during hit
	enemy.velocity = Vector2.ZERO
	hit_timer = 0.0
	_play_hit_effect()
	super()  # Travel to animation - blend position updates automatically

func process_physics(delta: float) -> State:
	var enemy: Enemy = parent as Enemy
	
	hit_timer += delta
	
	# Stop movement during hit
	enemy.velocity = Vector2.ZERO
	
	# Return to idle after hit duration
	if hit_timer >= hit_duration:
		return idle_state
	
	return null

func exit() -> void:
	var enemy: Enemy = parent as Enemy
	hit_timer = 0.0
	# Set invulnerability timer when leaving hit state
	enemy.hit_cooldown_timer = enemy.data.hit_invulnerability
	
func _play_hit_effect() -> void:
	var enemy: Enemy = parent as Enemy
	# Create a tween for the hit effect
	var tween = get_tree().create_tween()
	tween.set_parallel(true)  # Allow rotation and position to animate simultaneously
	
	# Store original position for shake effect
	var original_position = enemy.animated_sprite.position
	
	# Rotation shake - rotate back and forth
	tween.tween_property(enemy.animated_sprite, "rotation_degrees", -15.0, 0.08).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(enemy.animated_sprite, "rotation_degrees", 15.0, 0.12).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_property(enemy.animated_sprite, "rotation_degrees", -8.0, 0.08).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_property(enemy.animated_sprite, "rotation_degrees", 0.0, 0.12).set_ease(Tween.EASE_OUT)
	
	# Position shake - shake horizontally and vertically
	tween.tween_property(enemy.animated_sprite, "position", original_position + Vector2(1, -1), 0.05)
	tween.chain().tween_property(enemy.animated_sprite, "position", original_position + Vector2(-1, 1), 0.05)
	tween.chain().tween_property(enemy.animated_sprite, "position", original_position, 0.1).set_ease(Tween.EASE_OUT)
