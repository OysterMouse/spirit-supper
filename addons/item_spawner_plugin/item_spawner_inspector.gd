@tool
extends EditorInspectorPlugin

var editor_plugin: EditorPlugin

func _init(p: EditorPlugin) -> void:
    editor_plugin = p

func can_handle(object: Object) -> bool:
    # Diagnostic logging to help editor debugging
    if not object:
        print("ItemSpawnerInspector: can_handle called with null object")
        return false
    var s = object.get_script()
    var script_path = "(none)"
    if s and s.resource_path:
        script_path = s.resource_path
    var has_spawn = object.has_method("spawn_item")
    var has_possible = false
    var val = null
    # safe property access
    if object.get_script() != null:
        if object.has("possible_items"):
            val = object.get("possible_items")
    has_possible = val != null
    print("ItemSpawnerInspector: can_handle? node=", object.name, " type=", typeof(object), " script=", script_path, " has_spawn=", has_spawn, " has_possible=", has_possible)

    if s and s.resource_path:
        if s.resource_path.ends_with("item_spawner.gd"):
            return true
    if has_spawn:
        return true
    if has_possible:
        return true
    return false

func parse_begin(object: Object) -> void:
    print("ItemSpawnerInspector: parse_begin for node=", object.name, " script=", (object.get_script() and object.get_script().resource_path))
    var vb = VBoxContainer.new()
    var title = Label.new()
    title.text = "Item Spawner Tools"
    vb.add_child(title)

    var items_option = OptionButton.new()
    items_option.name = "items_option"
    var items = []
    if object.has("possible_items"):
        items = object.possible_items
    for i in range(items.size()):
        var it = items[i]
        var name = "(null)"
        if it and it.has("item_name"):
            name = str(it.item_name)
        else:
            name = "Item %d" % i
        items_option.add_item(name, i)
    vb.add_child(items_option)

    var h = HBoxContainer.new()
    var btn_spawn = Button.new()
    btn_spawn.text = "Spawn Selected"
    h.add_child(btn_spawn)
    var btn_rand = Button.new()
    btn_rand.text = "Spawn Random"
    h.add_child(btn_rand)
    vb.add_child(h)

    btn_spawn.pressed.connect(Callable(self, "_on_spawn_pressed"), [object, items_option])
    btn_rand.pressed.connect(Callable(self, "_on_spawn_random"), [object])

    add_custom_control(vb)

func _on_spawn_pressed(object: Object, items_option: OptionButton) -> void:
    var idx = items_option.get_selected_id()
    _spawn_for_object(object, idx)

func _on_spawn_random(object: Object) -> void:
    if not object.has("possible_items"):
        return
    var list = object.possible_items
    if list.empty():
        return
    var idx = randi() % list.size()
    _spawn_for_object(object, idx)

func _spawn_for_object(object: Object, idx: int) -> void:
    if not object or not object.has("possible_items"):
        return
    var list: Array = object.possible_items
    if idx < 0 or idx >= list.size():
        return
    var item_data = list[idx]
    if not item_data:
        return
    var packed: PackedScene = item_data.world_item_scene
    if not packed:
        push_warning("Item Spawner: world_item_scene missing for %s" % item_data)
        return

    var inst = packed.instantiate()
    if inst:
        if not Engine.is_editor_hint():
            if inst.has_method("setup"):
                inst.setup(item_data)
        else:
            # editor: avoid calling runtime setup on placeholder instances; apply safe preview data
            if inst.has_node("Item"):
                var sprite = inst.get_node("Item")
                if sprite and sprite is Sprite2D:
                    sprite.texture = item_data.texture

    if inst is Node2D and object is Node2D:
        inst.position = object.position
        if inst.has_method("set_z_index"):
            inst.z_index = 100

    var parent: Node = object.get_parent()
    if not parent:
        parent = editor_plugin.get_editor_interface().get_edited_scene_root()
        if not parent:
            parent = editor_plugin.get_editor_interface().get_scene_tree().get_root()

    var ur = editor_plugin.get_undo_redo()
    ur.create_action("Spawn Item")
    ur.add_do_method(parent, "add_child", inst)
    ur.add_undo_method(parent, "remove_child", inst)
    ur.commit_action()

    var selection = editor_plugin.get_editor_interface().get_selection()
    if selection:
        selection.clear()
        selection.add_node(inst)
