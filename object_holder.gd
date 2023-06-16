extends Area2D

@onready var my_object = $InstancePlaceHolder 
var is_holding_object = false
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


# Called when the node enters the scene tree for the first time.
func _ready():
	my_player = get_node("../../Player")






func _on_area_entered(area):
	#prevent object holder from detecting its parents object to hold it self 

	if is_holding_object == false and area.name != "Plate": 
		my_object = area
		my_object.get_parent().remove_child(my_object)
		$CollisionShape2D.set_deferred("disabled", true)
		$ReleaseArea/ReleaseCollision.set_deferred("disabled", false)
		$Sprite2D.texture = my_object.get_node("Sprite2D").texture
	
	else:
		print("rejected ", area.name) 
		return
 


func release_object(area):

	$CollisionShape2D.disabled = false
	is_holding_object = false


func _on_release_area_area_entered(area):
	$CollisionShape2D.set_deferred("disabled", false)
	$ReleaseArea/ReleaseCollision.set_deferred("disabled", true)
	
	
	main.get_node("Ysort").add_child(my_object)

	my_object.global_position = $ReleaseArea/ReleaseCollision.global_position

	$Sprite2D.texture = null

	is_holding_object = false
	my_object = null
