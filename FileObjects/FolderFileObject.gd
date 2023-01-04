extends FileObject
class_name FolderFileObject

func save_content():
	return

func load_content():
	$VBoxContainer/TextEdit.text = local_filename.replace("/","")
	return

func find_valid_name() -> void:
	var d:DirAccess = DirAccess.new()
	var num:int = 0
	while d.dir_exists(Global.dir+"/Folder"+str(num)+"/"):
		num += 1
	local_filename = "Folder"+str(num)+"/"
	d.make_dir(Global.dir+"/"+local_filename)
	return
