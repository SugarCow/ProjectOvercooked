extends Node2D

var time_elapsed = 0
@onready var customer = load("res://Customer.tscn")
@onready var main = get_tree().current_scene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_elapsed % 5 == 0 and time_elapsed != 0:
		spawn_customer()
		time_elapsed = 0
	


func _on_timer_timeout():
	time_elapsed += 1
	
func spawn_customer():
	var new_customer = customer.instantiate()
	main.get_node("Ysort").add_child(new_customer)
	new_customer.global_position = self.global_position
