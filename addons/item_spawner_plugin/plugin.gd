@tool
extends EditorPlugin

var inspector_plugin: EditorInspectorPlugin = null

func _enter_tree() -> void:
    var path = "res://addons/item_spawner_plugin/item_spawner_inspector.gd"
    if not ResourceLoader.exists(path):
        print("Item Spawner Plugin: inspector script not found at %s" % path)
        return
    var script = load(path)
    if not script:
        print("Item Spawner Plugin: failed to load inspector script")
        return
    call_deferred("_create_inspector", script)

func _create_inspector(script) -> void:
    var inst = null
    # instantiate inspector plugin (avoid try/except - not supported in GDScript)
    inst = script.new(self)
    if inst:
        inspector_plugin = inst
        add_inspector_plugin(inspector_plugin)

func _exit_tree() -> void:
    if inspector_plugin:
        remove_inspector_plugin(inspector_plugin)
        inspector_plugin = null
