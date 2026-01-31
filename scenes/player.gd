class_name Player
extends CharacterBody2D

@onready var animations = $AnimationTree
@onready var state_machine = $StateMachine
@onready var input_component: Node = $Components/InputComponent
@onready var inventory: Inventory = $Inventory
@onready var hotbar: Hotbar = $Hotbar

@export var move_speed: float = 75

var playback: AnimationNodeStateMachinePlayback
var direction: Vector2
var last_direction: Vector2 = Vector2.RIGHT
var current_tool: DataTypes.Tools = DataTypes.Tools.NONE

func _ready() -> void:
	playback = animations["parameters/playback"]
	if hotbar:
		hotbar.inventory = inventory
	state_machine.init(self, playback, input_component)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	if direction:
		last_direction = direction
	update_animation_params()
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	get_equipped_tool()
	state_machine.process_frame(delta)

func update_animation_params():
	if direction == Vector2.ZERO:
		return
	animations["parameters/Idle/blend_position"] = direction
	animations["parameters/Walk/blend_position"] = direction
	animations["parameters/Attack_1/blend_position"] = direction
	animations["parameters/Attack_2/blend_position"] = direction
	animations["parameters/Chop/blend_position"] = direction

func pickup_item(item: ItemData) -> void:
	inventory.add_item(item)

func get_equipped_tool() -> ToolData:
	if hotbar:
		return hotbar.get_selected_tool()
	return null
