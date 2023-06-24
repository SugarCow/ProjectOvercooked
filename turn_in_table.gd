extends StaticBody2D

@onready var anim = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
var menu = ["RawSteak"]
var order_queue = []
func _ready():
	anim.play("animate")
	$OrderTimer.timeout.connect(_new_order)





func _on_turn_in_area_area_entered(area):
	print(area.get_node("ObjectHolder").my_object.name)
	
	if area.get_node("ObjectHolder").my_object.get_node("Object").is_completed_object == true:
		print(area.get_node("ObjectHolder").my_object.get_node("Object").current_recipe[0])
		if order_queue.has(area.get_node("ObjectHolder").my_object.get_node("Object").current_recipe[0]) == true:
			print("order turned in")
			area.queue_free()
			area.get_node("ObjectHolder").is_holding_object = false
		else: 
			print("nope")
	

func _new_order():
	order_queue.append(menu.pick_random())
	print("order added")

