extends Area2D


var objectType
var my_player

enum { 
	WALK,
	HOLD_PLATE,
	DASH
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
	var main = get_tree().current_scene
	main.add_child(get_parent())
#	var dropoff_location = my_player.dropOffPoint.position
	get_parent().global_position = my_player..global_position


func _on_area_entered(area):
	print("object_grabbed")
	my_player.states = HOLD_PLATE
	my_player.my_object = get_parent()
	print(my_player.my_object)
#	queue_free()
#	get_parent().queue_free()

	
