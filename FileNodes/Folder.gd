extends FileNode
class_name FolderNode

func get_data_type():
	return "folder"

func folder_get_title():
	return %LineEdit.text

func save_content():
	if Global.dir == "/":
		return
	if local_filename == "":
		find_valid_name()
	return

func get_dict() -> Dictionary:
	var ret_val : Dictionary = super.get_dict();
	ret_val["title"] = folder_get_title();
	return ret_val;

func load_content():
	return

func recursive_delete(path:String):
	var dir:DirAccess = DirAccess.open(path)
	for f in dir.get_files():
		dir.remove(f)
	for d in dir.get_directories():
		recursive_delete(path+d+'/')
	DirAccess.remove_absolute(path)
	return

func delete_content():
	if DirAccess.dir_exists_absolute(Global.dir+'/'+local_filename):
		recursive_delete(Global.dir+'/'+local_filename)
	

func folder_set_title(string:String):
	%LineEdit.text = string
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

func _on_button_pressed():
	Global.proj_editor.folder_display_name_stack.push_back(folder_get_title())
	Global.proj_editor.load_project(Global.dir_in_project+'/'+local_filename.replace("/",""))
