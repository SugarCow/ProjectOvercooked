extends Area2D

@onready var my_object = $InstancePlaceHolder 
var is_holding_object = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	#prevent object holder from detecting its parents object to hold it self 
	print(area)
	print(get_parent().get_node("Object"))
	print(get_parent())
	if area.name == "Object" and is_holding_object == false and area != get_parent().get_node("Object"): 
		print(area.get_parent().name)
#		is_holding_object = true
		my_object = area
		print(my_object)
#		my_object.remove_from_world()
		$CollisionShape2D.set_deferred("disabled", true)
	else:
		print("rejected ", area.name) 
		return
 


func _on_area_exited(area):
	$CollisionShape2D.disabled = false
	is_holding_object = false
