extends Area2D


@onready var objectType
var my_holder
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
	match objectType:
		"plate": 
#			print("i am a plate")
			pass
		"raw steak": 
			pass 
#			print("i am a steak ")
	
#dropping off item
func dropoff():
	print(my_holder.name)
	$CollisionShape2D.set_deferred("disabled", false)
	remove_from_holder()

	get_parent().global_position = my_holder.get_node("pivotPoint/Grab/dropOffPoint").global_position
		
	my_holder.is_holding_object = false
	if my_holder.name == "Player":
		my_holder.states = WALK
	my_holder = null
	
#picking up item
func _on_area_entered(area):
	if area.owner.name == "Player":
		my_holder = area.owner
	else: 
		my_holder = area
	
	print(area.name)
	
	if my_holder.is_holding_object == true:
		return
	my_holder.my_object = get_parent()
		
	if my_holder.name == "Player":
		if objectType == "Plate":
			remove_from_world()
			my_holder.states = HOLD_PLATE
			my_holder.holding_plate = true
			my_holder.get_node("pivotPoint/Grab/GrabBox").disabled = true
		else:
			remove_from_world()
			my_holder.states = HOLD_ITEM
			my_holder.holding_plate = false
			my_holder.get_node("SpriteLocation").add_child(get_parent())
			get_parent().position = my_holder.get_node("SpriteLocation").position

	#disable the player's grab box  
	
	print(my_holder.name)
	my_holder.is_holding_object = true

#	$CollisionShape2D.disabled = true
	if my_holder.name == "Player":
		$CollisionShape2D.set_deferred("disabled", true)


func remove_from_world():
	main.get_node("Ysort").remove_child(get_parent())
	
func remove_from_holder():
	if objectType != "plate" and my_holder.name == "Player":
		my_holder.get_node("SpriteLocation").remove_child(get_parent())
	else: #removes from the holder that is not the player so this could be a prep table or stove
		my_holder.get_node("SpriteLocation").remove_child(get_parent())
	main.get_node("Ysort").add_child(get_parent())
