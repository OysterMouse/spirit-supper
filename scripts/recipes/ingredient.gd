extends HBoxContainer

@onready var texture: TextureRect = $Texture
@onready var label: Label = $Label

var crafting_ingredient: CraftingIngredient

func _ready() -> void:
	if !crafting_ingredient:
		queue_free()
		return
	
	var item: ItemData = crafting_ingredient.item
	texture.texture = item.texture
	label.text = "%s x %d" % [item.item_name, crafting_ingredient.count]
