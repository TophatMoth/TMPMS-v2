extends FileNode
class_name ImageNode

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
	var dir:DirAccess = DirAccess.open(Global.dir)
	dir.remove(local_filename)

func find_valid_filename() -> void:
	if Global.dir == "/":
		return;
	print("No Valid Image Path Gromit!")
	return
