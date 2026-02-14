extends Camera2D

func _process(delta: float) -> void:
    if get_parent() == null:
        return
    
    if Input.is_action_just_pressed("zoom_in"):
        zoom *= 1.1  # Zoom in by increasing the zoom factor
    elif Input.is_action_just_pressed("zoom_out"):
        zoom *= 0.9  # Zoom out by reducing the zoom factor