extends Area2D


var objectType
var my_player
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


#@onready var my_player = get_node("../Ysort/Player")
var grabable_objects = ["plate", "raw steak"]
var state
# Called when the node enters the scene tree for the first time.
func _ready():
	
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
	
func dropoff():

	main.get_node("Ysort").add_child(my_player.my_object)
#	var dropoff_location = my_player.dropOffPoint.position
	get_parent().global_position = my_player.get_node("pivotPoint/Grab/dropOffPoint").global_position
	my_player.hands_full = false
	my_player.states = WALK
	

func _on_area_entered(area):
	if my_player.hands_full == true:
		return
	if objectType == "plate":
		my_player.states = HOLD_PLATE
	else:
		my_player.states = HOLD_ITEM
	my_player.my_object = get_parent()
	my_player.get_node("pivotPoint/Grab/GrabBox").disabled = true
	print(my_player.my_object)
#	queue_free()
#	get_parent().queue_free()

	main.get_node("Ysort").remove_child(get_parent())
	my_player.hands_full = true
	if objectType == "plate":
		my_player.holding_plate = true
	else:
		my_player.holding_plate = false
		my_player.get_node("SpriteLocation").add_child(get_parent())
		get_parent().position = my_player.get_node("SpriteLocation").position
#	get_parent().set_pause(true)
