extends Node2D

@onready var line = $SubViewportContainer/SubViewport/Line2D
var base_position: Vector2 = Vector2(93, 275)
var max_length = 128

func _process(delta: float) -> void:
	if not line:
		return
	
	var mous_pos: Vector2 = get_global_mouse_position()
	
	var direction: Vector2 = mous_pos - base_position
	var distance: float = direction.length()
	if distance < max_length:
		mous_pos = base_position + direction.normalized() * max_length
		
	line.set_point_position(0, line.to_local(base_position))
	line.set_point_position(1, line.to_local(mous_pos))
		
	
	
