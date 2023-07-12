extends FileNode
class_name ImageNode


func _enter_tree():
	$FileDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	if local_filename == "":
		$FileDialog.show()

func get_data_type():
	return "image"
	
func save_content():
	return

func load_content():
	if Global.dir == "/":
		return;
	var img:Image = Image.new()
	img.load(Global.dir+'/'+local_filename)
	%TextureRect.texture = ImageTexture.create_from_image(img)
	return

func delete_content():
	if local_filename != "":
		var dir:DirAccess = DirAccess.open(Global.dir)
		dir.remove(local_filename)

func find_valid_filename(ext:String) -> void:
	if Global.dir == "/":
		return;
	var num:int = 0
	while FileAccess.file_exists(Global.dir+"/Image"+str(num)+"."+ext):
		num += 1
	local_filename = "Image"+str(num)+"."+ext
	return

func image_selected(path:String):
	if local_filename != "":
		delete_content()
	else:
		find_valid_filename(path.get_extension())
	DirAccess.copy_absolute(path,Global.dir+'/'+local_filename)
	load_content()
	Global.proj_editor.save_data()

func select_canceled():
	if local_filename == "":
		remove_node()
