extends Window

class_name FileObject

func _ready():
	get_viewport().size_changed.connect(viewport_resized);

func update_position():
	pass;

func viewport_resized():
	pass;
