class_name ItemData
extends Resource

@export var item_name: String
@export var texture: Texture2D
@export var description: String
@export var stack_size: int = 1
@export var is_tool: bool = false
@export var item_type: DataTypes.ItemType = DataTypes.ItemType.NONE
@export var is_consumable: bool = false
@export var health_restore: int = 0
@export var stamina_restore: int = 0
var world_item_scene: PackedScene = preload("res://scenes/game_item.tscn")

# Override this in derived classes or use signals for custom effects
func use_item(player) -> bool:
	if not is_consumable:
		return false
	
	if health_restore > 0:
		if player.has_method("heal"):
			player.heal(health_restore)
	
	if stamina_restore > 0:
		if player.has_method("restore_stamina"):
			player.restore_stamina(stamina_restore)
	
	return true  # Item was used successfully
