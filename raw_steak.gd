extends Node2D

const object_type = "steak"
var recipe
@onready var my_object = $Object
@onready var my_player = get_node("../Player")
func _ready():

	my_object.objectType = "steak"
	my_object.my_player = my_player
	self.add_child(my_object)
