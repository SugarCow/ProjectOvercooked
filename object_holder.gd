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



	

func _on_area_entered(area):
	#prevent object holder from detecting its parents object to hold it self 

	if is_holding_object == false and self.owner.name != "Stove":
		if area.name != "Plate" and is_plate == false: 
			my_object = area
			my_object.get_parent().remove_child(my_object)
			$CollisionShape2D.set_deferred("disabled", true)
			$ReleaseArea/ReleaseCollision.set_deferred("disabled", false)
			$Sprite2D.texture = my_object.get_node("Sprite2D").texture
		
		elif area.name == "Plate" and is_plate == false:
			my_object = area
			my_object.get_parent().remove_child(my_object)
			$CollisionShape2D.set_deferred("disabled", true)
			$ReleaseArea/ReleaseCollision.set_deferred("disabled", false)
			$Sprite2D.texture = my_object.get_node("Sprite2D").texture
			$Sprite2D/FoodImage.texture = my_object.get_node("ObjectHolder/Sprite2D").texture
		
		elif area.name.contains("Plate") == false and is_plate == true and area.is_raw == false :
			my_object = area

			my_object.get_parent().remove_child(my_object)
#			print(my_object.get_parent().name)
			$CollisionShape2D.set_deferred("disabled", true)
#			$ReleaseArea/ReleaseCollision.set_deferred("disabled", false)
			$Sprite2D.texture = my_object.get_node("Sprite2D").texture

			get_parent().add_to_recipe(my_object.name)
			get_parent().is_completed_object = true

			$Sprite2D/FoodImage.texture = my_object.get_node("Sprite2D").texture
#		print($pivotPoint/FoodImage.texture)
		
		else:
			print("rejected ", area.name) 
			return
	
	else: 
		if area.name != "Plate" and is_plate == false: 
			my_object = area
			my_object.global_position = Vector2(self.global_position.x, self.global_position.y - 10)
#			my_object.get_parent().remove_child(my_object)
			$CollisionShape2D.set_deferred("disabled", true)
			$ReleaseArea/ReleaseCollision.set_deferred("disabled", false)
			$Sprite2D.texture = my_object.get_node("Sprite2D").texture
			print(self.owner.name)
			self.owner.get_node("CookTime").start()
			print(self.owner.get_node("CookTime").time_left)
			


func release_object(area):
	$CollisionShape2D.disabled = false
	is_holding_object = false


func _on_release_area_area_entered(area):

	$CollisionShape2D.set_deferred("disabled", false)
	if is_plate == false: 
		$ReleaseArea/ReleaseCollision.set_deferred("disabled", true)
#		print(my_object.get_node("CollisionShape2D"))
#		my_object.get_node("CollisionShape2D").disabled = true

		main.get_node("Ysort").add_child(my_object)
		my_object.global_position = $ReleaseArea/ReleaseCollision.global_position
		$Sprite2D/FoodImage.texture = null
		$Sprite2D.texture = null
		is_holding_object = false
		my_object = null
