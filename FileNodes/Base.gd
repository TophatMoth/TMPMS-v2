extends GraphNode
class_name FileNode

var local_filename : String = "": #EX: Text1.txt, Image1.png, Folder1/
	set(value):
		local_filename = value;
		title = value;

func get_data_type():
	print("get_data_type was not overridden!")
	return "get_data_type was not overridden!"

func _ready():
	# Connect to its own signals
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
		"position":[position_offset[0],position_offset[1]],
		"size":[size[0],size[1]]
	};

func load_content() -> void:
	print("load_content was not overridden!")

func delete_content() -> void:
	print("delete_content was not overridden!")

func remove_node():
	delete_content()
	Global.proj_editor.graph_edit.remove_node(self);
