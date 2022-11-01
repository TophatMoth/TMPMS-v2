extends Camera2D

@onready var previous_mouse_pos : Vector2i = Vector2i.ZERO;
@export var coord_label : Label = null;

func _process(_delta):
	var move_vector : Vector2i = Vector2i.ZERO;
	
	if (Input.get_mouse_button_mask() & MOUSE_BUTTON_MASK_RIGHT):
		var mouse_pos : Vector2i = Global.mouse_position;
		move_vector = previous_mouse_pos - mouse_pos;
	previous_mouse_pos = Global.mouse_position;
	
	if move_vector != Vector2i.ZERO:
		position += Vector2(move_vector);
		Global.emit_camera_moved();
		if coord_label != null:
			coord_label.text = str(Vector2i(position));
