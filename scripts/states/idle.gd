extends State

@onready var hotbar: Hotbar = $"../../Hotbar"


@export var move_state: State
@export var attack_state: State
@export var chop_state: State

func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	if input_component.get_input_direction():
		return move_state
	
	# Check for item usage first
	if Input.is_action_just_pressed("use"):
		if use_item():
			return null  # Stay in idle after using item
	
	# Then check for tool usage
	return use_equipped_tool()

func process_physics(delta: float) -> State:
	return null

func use_equipped_tool() -> State:
	match parent.current_tool:
		DataTypes.Tools.SWORD:
			if Input.is_action_just_pressed("use"):
				return attack_state
		DataTypes.Tools.AXE:
			if Input.is_action_just_pressed("use"):
				return chop_state
	return null

func use_item() -> bool:
	var item = hotbar.get_selected_item()
	if item and item.is_consumable:
		if item.use_item(parent):
			# Consume one item from inventory
			var slot_index = hotbar.selected_index
			parent.inventory.consume_item(slot_index, 1)
			print("Used item: ", item.item_name)
			return true
	return false
	
