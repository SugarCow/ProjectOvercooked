extends Area2D

@onready var my_object = $InstancePlaceHolder 
var is_holding_object = false
var my_player
@export var is_plate =false
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
	$ReleaseArea/ReleaseCollision.set_deferred("disabled", true)


func _process(delta):
	if is_holding_object == true and my_object.name.contains("Plate") == true: 
		$Sprite2D.texture = my_object.get_node("ObjectHolder/Sprite2D").texture
	elif is_holding_object == true and my_object.name.contains("Plate") == false:
		$Sprite2D.texture = my_object.get_node("Sprite2D").texture
	else: 
		$Sprite2D.texture = null
	

func _on_area_entered(area):
	if is_holding_object == false and self.owner.name != "Stove":
		if area.name != "Plate" and is_plate == false:
			my_object = area
			my_object.get_parent().remove_child(my_object)
			$CollisionShape2D.set_deferred("disabled", true)
			$ReleaseArea/ReleaseCollision.set_deferred("disabled", false)
		
			$Sprite2D.texture = my_object.get_node("Sprite2D").texture
			is_holding_object = true
		
		elif area.name == "Plate" and is_plate == false:
			my_object = area
#			my_object.get_parent().remove_child(my_object)
			my_object.global_position = Vector2(self.global_position.x, self.global_position.y )
			$CollisionShape2D.set_deferred("disabled", true)
			$ReleaseArea/ReleaseCollision.set_deferred("disabled", false)
			print(my_object.name)
#			$Sprite2D/FoodImage.texture = my_object.get_node("ObjectHolder/Sprite2D2").texture
#			$food.texture = my_object.get_node("ObjectHolder/Sprite2D/FoodImage").texture
			is_holding_object = true
		
		elif area.name.contains("Plate") == false and is_plate == true :
			my_object = area
			my_object.get_parent().remove_child(my_object)
			$CollisionShape2D.set_deferred("disabled", true)
			my_object.get_node("Object").add_to_recipe(my_object.name)
			my_object.get_node("Object").is_completed_object = true

			$Sprite2D/FoodImage.texture = my_object.get_node("Sprite2D").texture
			is_holding_object = true

		
		else:
			print("rejected ", area.name) 
			return
	
	else: 
		if area.name != "Plate" and is_plate == false:
			is_holding_object = true 
			my_object = area
			my_object.global_position = Vector2(self.global_position.x, self.global_position.y - 500)
			

			$CollisionShape2D.set_deferred("disabled", true)
			$ReleaseArea/ReleaseCollision.set_deferred("disabled", false)
			$Sprite2D.texture = my_object.get_node("Sprite2D").texture
			
			self.owner.get_node("CookTime").start()
			
			


func release_object(area):
	$CollisionShape2D.disabled = false
	is_holding_object = false


func _on_release_area_area_entered(area):
	$CollisionShape2D.set_deferred("disabled", false)
	if is_plate == false: 
		$ReleaseArea/ReleaseCollision.set_deferred("disabled", true)

		main.get_node("Ysort").add_child(my_object)
		my_object.global_position = $ReleaseArea/ReleaseCollision.global_position
		$Sprite2D/FoodImage.texture = null
		$Sprite2D.texture = null
		is_holding_object = false
		my_object = null
