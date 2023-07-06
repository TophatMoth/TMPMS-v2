extends FileNode
class_name FolderNode

func get_object_type():
	return "folder"

func folder_get_title():
	return $VBoxContainer/TextEdit.text

func save_content():
	return

func get_dict() -> Dictionary:
	var ret_val : Dictionary = super.get_dict();
	ret_val["title"] = folder_get_title();
	return ret_val;

func load_content():
	if Global.dir == "/":
		return;
	$VBoxContainer/TextEdit.text = local_filename.replace("/","")
	return

func folder_set_title(string:String):
	$VBoxContainer/TextEdit.text = string
	return

func find_valid_name() -> void:
	if Global.dir == "/":
		return;
	var num:int = 0
	while DirAccess.dir_exists_absolute(Global.dir+"/Folder"+str(num)+"/"):
		num += 1
	local_filename = "Folder"+str(num)+"/"
	DirAccess.make_dir_absolute(Global.dir+"/"+local_filename)
	return
