extends Node

@onready var chop_tree = $ChopTree

func play_sound(key: String) -> void:
	var sound = get_node_or_null(NodePath(key))
	if sound == null:
		sound = get(key)

	if sound is AudioStreamPlayer:
		sound.play()
	else:
		push_warning("Sound '%s' not found or is not an AudioStreamPlayer." % key)
