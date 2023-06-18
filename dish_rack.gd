extends StaticBody2D

@onready var object_type = "dish_pile"
var recipe
@onready var food_image = $foodImage
@onready var object 

enum { 
	WALK,
	HOLD_PLATE,
	HOLD_ITEM,
	DASH,
	WALK_WITH_PLATE,
	DASH_WITH_PLATE,
	WALK_WITH_ITEM, 
	DASH_WITH_ITEM
}


func _ready():

	find_and_set_sprite(object_type)
	
	match object_type:
		"rawSteak":
			object = load("res://raw_steak.tscn")
		"dish_pile":
			object = load("res://plate.tscn")
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
#			food_image.texture = load(sprite_path)
#			food_image.scale = Vector2(.5,.5)
			break
		
		file_name = dir.get_next()


func _on_grab_box_area_entered(area):
	print(area.name)
	
	var my_object = object.instantiate()
	print(my_object.name)
	var main = get_tree().current_scene
	var temp = main.get_node("Ysort")
	temp.add_child(my_object)
	print(my_object.get_children())
#	my_object.global_position = self.global_position
	print(my_object.name)
	print(my_object.get_node("ObjectHolder").get_children())
	if my_object.name.contains("Plate") == true:
		area.owner.states = HOLD_PLATE
		area.owner.my_object = my_object
	else:
		area.owner.grab_object(my_object)
