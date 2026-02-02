class_name Enemy
extends CharacterBody2D

var data : EnemyData
@onready var hurt_component: HurtComponent = $HurtComponent

func _ready() -> void:
	z_index = 100
	hurt_component.damage_received.connect(_on_damage_received)

func setup(_data: EnemyData) -> void:
	data = _data
	$Sprite.texture = _data.texture

func _on_damage_received(amount: int, tool_type: DataTypes.Tools) -> void:
	data.health -= amount
	
	if data.health <= 0:
		queue_free()
