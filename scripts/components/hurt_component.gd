class_name HurtComponent
extends Area2D

signal damage_received(amount: int, tool_type: DataTypes.Tools)

func take_damage(amount: int, tool_type: DataTypes.Tools) -> void:
	damage_received.emit(amount, tool_type)
