extends StaticBody2D

@onready var anim = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
var menu = ["Steak"]
var order_queue = []
func _ready():
	anim.play("animate")
	$OrderTimer.timeout.connect(_new_order)





func _on_turn_in_area_area_entered(area):
	print(area.name)
	
	if area.is_completed_object == true:

		if order_queue.has(area.current_recipe[0]) == true:
			print("order turned in")
			area.queue_free()
			
		else: 
			print("nope")
	

func _new_order():
	order_queue.append(menu.pick_random())

