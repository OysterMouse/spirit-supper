extends Sprite2D

@onready var player: Player = $"../Player"

func ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("transition")
