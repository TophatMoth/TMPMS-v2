extends FileNode
class_name TextNode

func get_data_type():
	return "text"

func save_content():
	if Global.dir == "/":
		return;
	if local_filename == "":
		find_valid_name()
	var f:FileAccess = FileAccess.open(Global.dir+"/"+local_filename,FileAccess.WRITE)
	f.store_string(str(%TextEdit.text))
	return

func load_content():
	if Global.dir == "/":
		return;
	var f:FileAccess = FileAccess.open(Global.dir+"/"+local_filename,FileAccess.READ)
	%TextEdit.text = f.get_as_text()
	return

func delete_content():
	var dir:DirAccess = DirAccess.open(Global.dir)
	dir.remove(local_filename)

func find_valid_name()->void:
	if Global.dir == "/":
		return;
	var num:int = 0
	while FileAccess.file_exists(Global.dir+"/Text"+str(num)+".txt"):
		num += 1
	local_filename = "Text"+str(num)+".txt"
	var f:FileAccess = FileAccess.open(Global.dir+'/'+local_filename,FileAccess.WRITE)
	f.store_string("")
	return
