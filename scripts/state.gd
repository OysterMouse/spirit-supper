class_name State
extends Node

@export var animation_name : String

var parent : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var input_component : Node

func enter() -> void:
	playback.travel(animation_name)
	
	# Auto-play AnimatedSprite2D if parent has one
	if parent.has_node("AnimatedSprite"):
		var sprite = parent.get_node("AnimatedSprite")
		if sprite is AnimatedSprite2D and sprite.animation != "":
			sprite.play()
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
