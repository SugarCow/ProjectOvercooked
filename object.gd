extends Area2D


@export var objectType = "none"
var my_holder
var is_completed_object = false
var current_recipe = []
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
	objectType = get_parent().name
	match objectType:
		"Plate":
			print("im a plate")
		"RawSteak":
			pass
		"Steak":
			pass
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	match objectType:
#		"plate": 
##			print("i am a plate")
#			pass
#		"raw steak": 
#			pass 
##			print("i am a steak ")
	
#dropping off item
func dropoff(curr_holder, next_holder ):
	pass
#	if my_holder.name == "Player":
#		$CollisionShape2D.set_deferred("disabled", false)
#	else:
#		my_holder.release_object()
#	remove_from_holder(curr_holder, next_holder)
#
#	get_parent().global_position = my_holder.get_node("pivotPoint/Grab/dropOffPoint").global_position
#
#	my_holder.is_holding_object = false
#	if my_holder.name == "Player":
#		my_holder.states = WALK
#	my_holder = null
	
#picking up item
func _on_area_entered(area):
	pass
#	var new_holder
#	if area.owner.name == "Player":
#		new_holder = area.owner
#	else: 
#		new_holder = area
#
#	print(area.name)
#
#	if new_holder.is_holding_object == true:
#		return
#	new_holder.my_object = get_parent()
#
#	if new_holder.name == "Player":
#		if objectType == "Plate":
#			my_holder = new_holder
#			my_holder.my_object = get_parent()
#			remove_from_holder(my_holder, main)
#			my_holder.states = HOLD_PLATE
#			my_holder.holding_plate = true
#			my_holder.get_node("pivotPoint/Grab/GrabBox").disabled = true
#		else:
#			my_holder = new_holder
#			my_holder.my_object = get_parent()
#			remove_from_holder(my_holder, main)
#			my_holder.states = HOLD_ITEM
#			my_holder.holding_plate = false
#			my_holder.get_node("SpriteLocation").add_child(get_parent())
#			get_parent().position = my_holder.get_node("SpriteLocation").position
#	else:
#		if objectType == "Plate":
#			my_holder = new_holder
#			my_holder.my_object = get_parent()
#			remove_from_holder(my_holder, main)
#			my_holder.holding_plate = true
##			my_holder.get_node("pivotPoint/Grab/GrabBox").disabled = true
#		else:
#			my_holder = new_holder
#			my_holder.my_object = get_parent()
#			remove_from_holder(my_holder, main)
#			my_holder.get_node("SpriteLocation").add_child(get_parent())
#			get_parent().position = my_holder.get_node("SpriteLocation").position
#
#
#
#	my_holder.is_holding_object = true
#
##	$CollisionShape2D.disabled = true
#	if my_holder.name == "Player":
#		$CollisionShape2D.set_deferred("disabled", true)


#func remove_from_holder():
#	main.get_node("Ysort").remove_child(get_parent())
	
func remove_from_holder(holder, destination):
	pass
#	print(holder.name)
#	print(destination.name)
#	if objectType != "plate" and my_holder.name == "Player":
#		holder.get_node("SpriteLocation").remove_child(get_parent())
#	else: #removes from the holder that is not the player so this could be a prep table or stove
#		holder.get_node("SpriteLocation").remove_child(get_parent())
#
#	if destination.name == "World":
#		destination.get_node("Ysort").add_child(get_parent())
#	else:
#		destination.get_node("SpriteLocation").add_child(get_parent())

func add_to_holder(holder):
	print("hjellos")
	holder.get_node("ObjectHolder/SpriteLocation").add_child(get_parent())

func add_to_recipe(ingredient):
	current_recipe.append(ingredient)
	print(current_recipe[0])
