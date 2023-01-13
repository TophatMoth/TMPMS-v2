extends FileObject
class_name TextFileObject

func get_object_type():
	return "text"

func save_content():
	var f:FileAccess = FileAccess.open(Global.dir+"/"+local_filename,FileAccess.WRITE)
	f.store_string($TextEdit.text)
	return

func load_content():
	var f:FileAccess = FileAccess.open(Global.dir+"/"+local_filename,FileAccess.READ)
	$TextEdit.text = f.get_as_text()
	return

func find_valid_name()->void:
	var d:DirAccess = DirAccess.new()
	var num:int = 0
	while d.file_exists(Global.dir+"/Text"+str(num)+".txt"):
		num += 1
	local_filename = "Text"+str(num)+".txt"
	var f:FileAccess = FileAccess.open(Global.dir+'/'+local_filename,FileAccess.WRITE)
	f.store_string("")
	return
