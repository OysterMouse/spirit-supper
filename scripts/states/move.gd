extends State

@onready var hotbar: Hotbar = $"../../CanvasLayer/Hotbar"

@export var idle_state: State
@export var attack_state: State
@export var chop_state: State

func enter() -> void:
	super()

func process_input(event: InputEvent) -> State:
	# Check for item usage first
	if input_component.get_use_input():
		if use_item():
			return null  # Stay in idle after using item
	
	# Then check for tool usage
	return use_equipped_tool()
	return null

func process_physics(delta: float) -> State:
	parent.direction = input_component.get_input_direction()

	parent.velocity = parent.direction * parent.move_speed
	parent.move_and_slide()

	# Track last facing direction
	if parent.direction != Vector2.ZERO:
		parent.last_direction = parent.direction

	if parent.velocity == Vector2.ZERO:
		return idle_state
	return null

func use_equipped_tool() -> State:
	match parent.current_tool:
		DataTypes.Tools.SWORD:
			if input_component.get_use_input():
				return attack_state
		DataTypes.Tools.AXE:
			if input_component.get_use_input():
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
	
