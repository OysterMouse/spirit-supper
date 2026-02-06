class_name State
extends Node

@export var animation_name : String
@export var use_blend_space: bool = false

var parent : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var input_component : Node

func enter() -> void:
	playback.travel(animation_name)
	
	if use_blend_space and parent.has_method("set_blend_position"):
		update_blend_direction()

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func update_blend_direction() -> void:
	if use_blend_space and parent.has_method("set_blend_position"):
		var direction = parent.velocity.normalized()
		if direction.length() > 0.1:
			parent.set_blend_position(animation_name, direction)
