extends Area2D


var objectType
var my_player
@onready var main = get_tree().current_scene
enum { 
	WALK,
	HOLD_PLATE,
	DASH,
	WALK_WITH_PLATE,
	DASH_WITH_PLATE
}

enum { 
	plate, 
	raw_steak
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
		plate: 
			print("i am a plate")
		raw_steak: 
			pass
	
func dropoff():

	main.get_node("Ysort").add_child(my_player.my_object)
#	var dropoff_location = my_player.dropOffPoint.position
	get_parent().global_position = my_player.get_node("dropOffPoint").global_position
	my_player.hands_full = false
	my_player.states = WALK
	

func _on_area_entered(area):
	if my_player.hands_full == true:
		return
	print("object_grabbed")
	my_player.states = HOLD_PLATE
	my_player.my_object = get_parent()
	my_player.get_node("pivotPoint/Grab/GrabBox").disabled = true
	print(my_player.my_object)
#	queue_free()
#	get_parent().queue_free()

	main.get_node("Ysort").remove_child(get_parent())
	my_player.hands_full = true
	
#	get_parent().set_pause(true)
