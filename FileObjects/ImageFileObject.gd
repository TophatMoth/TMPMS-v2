extends FileObject
class_name ImageFileObject

func save_content():
	return

func load_content():
	var img:Image = Image.new()
	img.load(Global.dir+'/'+local_filename)
	var tex:ImageTexture = ImageTexture.new()
	tex.create_from_image(img)
	$TextureRect.texture = tex
	return

func find_valid_filename() -> void:
	print("No Valid Image Path Gromit!")
	return
