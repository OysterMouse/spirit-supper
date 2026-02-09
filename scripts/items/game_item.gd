class_name GameItem
extends Node2D

var data : ItemData
var velocity: Vector2 = Vector2.ZERO
var friction: float = 0.85  # Slow down over time
var pickup_enabled: bool = true  # Disable pickup while item is in motion

func _ready() -> void:
	z_index = 100

func setup(_data : ItemData):
	data = _data
	$Item.texture = data.texture

func _process(delta: float) -> void:
	if velocity != Vector2.ZERO:
		# Apply friction and movement
		velocity *= friction
		position += velocity * delta
		
		# Stop moving when velocity is very small
		if velocity.length() < 5:
			velocity = Vector2.ZERO
			pickup_enabled = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and pickup_enabled:
		body.pickup_item(data)
		queue_free()
