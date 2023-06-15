extends Area2D

@onready var my_object = $InstancePlaceHolder 
var is_holding_object = false
var my_player
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



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	#prevent object holder from detecting its parents object to hold it self 
	print(area.name)
	if is_holding_object == false and area.name != "Plate": 
		my_object = area
		my_object.get_parent().remove_child(my_object)
		$CollisionShape2D.set_deferred("disabled", true)
		
		
		$Sprite2D.texture = my_object.get_node("Sprite2D").texture
	
	else:
		print("rejected ", area.name) 
		return
 


func release_object(area):
	print(area.owner.name)
	$CollisionShape2D.disabled = false
	is_holding_object = false
