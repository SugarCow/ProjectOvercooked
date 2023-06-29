extends StaticBody2D

@onready var object_type = "rawSteak"

var recipe
@onready var food_image = $foodImage
@onready var object 
			
func _ready():

	find_and_set_sprite(object_type)
	
	match object_type:
		"rawSteak":
			object = load("res://raw_steak.tscn")
		
			



func find_and_set_sprite(target):
	var path = "res://assets/Ghostpixxells_pixelfood/"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if !dir.current_is_dir() and file_name.find(target) != -1:
			print("found!")
			dir.list_dir_end()
			var sprite_path = path + file_name
			food_image.texture = load(sprite_path)
			food_image.scale = Vector2(.5,.5)
			break
		
		file_name = dir.get_next()
	
	


func _on_grab_zone_area_entered(area):

	var my_object = object.instantiate()
	var main = get_tree().current_scene
	var temp = main.get_node("Ysort")
	temp.add_child(my_object)

	area.owner.grab_object(my_object)
