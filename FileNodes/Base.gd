extends GraphNode
class_name FileNode

var local_filename : String = "": #EX: Text1.txt, Image1.txt, Folder1/
	set(value):
		local_filename = value;
		title = value;

func get_data_type():
	print("FUNCTION WAS NOT OVERRIDDEN")
	return "FUNCTION WAS NOT OVERRIDDEN"

func _ready():
	# Connect to its own signals
	close_request.connect(close_button_pressed);
	resize_request.connect(func(new_size:Vector2):
		self.size = new_size;
	);

func find_valid_name() -> void:
	print("find_valid_name was not overridden!")
	return

func save_content() -> void:
	print("save_content was not overridden!")

func get_dict() -> Dictionary:
	return {
		"type":get_data_type(),
		"filename":local_filename,
		"position":position_offset,
		"size":size
	};

func load_content() -> void:
	print("load_content was not overridden!")

func close_button_pressed():
	# Temporary, later it should have a confirmation popup and delete the associated file
	queue_free();
