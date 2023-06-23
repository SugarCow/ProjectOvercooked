extends Node2D


@export var objectType = "none"
@export var is_raw = true
var my_holder
var is_completed_object = false
var current_recipe = []
@onready var cook_time = 0
@onready var main = get_tree().current_scene
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


#@onready var my_holder = get_node("../Ysort/Player")
var grabable_objects = ["plate", "raw steak"]
var state
# Called when the node enters the scene tree for the first time.
func _ready():
#	cook_time.timeout.connect(_on_cook_time_timeout)
	objectType = get_parent().name
	match objectType:
		"Plate":
			print("im a plate")
		"RawSteak":
			pass
		"Steak":
			pass
	

func _process(delta):
	if cook_time == 5:
		print("food is done")
		self.owner.is_raw = false 
		self.owner.is_cooked = true
	elif  cook_time >10:
		print("food is burnt")
		self.owner.is_burnt = true
	
#	if is_raw == false: 
#		print(self.owner.name)
#		self.owner.get_node("Sprite2D").texture = self.owner.cooked

func add_to_holder(holder):
	print("hjellos")
	holder.get_node("ObjectHolder/SpriteLocation").add_child(get_parent())

func add_to_recipe(ingredient):
	current_recipe.append(ingredient)
	print(current_recipe[0])

func _on_timeout():
	print("cook timer done")
	pass


func _on_cook_time_timeout():
	print("cook timer done")
	pass # Replace with function body.
