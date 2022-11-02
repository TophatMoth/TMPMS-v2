extends CanvasLayer
class_name ProjectUI

signal button_pressed(button : int);

enum {
	HOME, UP_FOLDER, CENTER_CAM,
	CENTER_FILES, SAVE, CLOSE,
	ADD_TEXTBOX, ADD_FOLDER, ADD_IMAGE
}

func press_button(button_id : int) -> void:
	#print(button_id);
	button_pressed.emit(button_id);
