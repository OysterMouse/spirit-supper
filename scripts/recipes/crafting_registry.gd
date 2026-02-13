class_name CraftingRegistry

static var recipes: Array[CraftingRecipe] = []
static var _loaded := false

static func ensure_loaded(path: String = "res://resources/recipes") -> void:
	if _loaded:
		return

	load_resources(path)

	if recipes.is_empty():
		_add_fallback_recipe()

	_loaded = true

static func load_resources(path: String) -> void:
	if !path.ends_with("/"):
		path += "/"

	recipes.clear()
	
	var dir = DirAccess.open(path)
	if !dir:
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir() and file_name.ends_with(".tres"):
			var loaded_resource := load(path + file_name)
			if loaded_resource is CraftingRecipe:
				recipes.append(loaded_resource as CraftingRecipe)
		file_name = dir.get_next()
static func _add_fallback_recipe() -> void:
	var log_item := load("res://resources/items/log.tres") as ItemData
	var axe_item := load("res://resources/tools/axe.tres") as ItemData

	if !log_item or !axe_item:
		return

	var ingredient := CraftingIngredient.new()
	ingredient.item = log_item
	ingredient.count = 3

	var output := CraftingIngredient.new()
	output.item = axe_item
	output.count = 1

	var recipe := CraftingRecipe.new()
	recipe.ingredients = [ingredient]
	recipe.output = output

	recipes.append(recipe)

static func get_craftable(inventory: Inventory) -> Array[CraftingRecipe]:
	var valid_recipes: Array[CraftingRecipe]
	
	for r in recipes:
		if r.can_craft(inventory):
			valid_recipes.append(r)
			
	return valid_recipes
