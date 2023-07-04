extends StaticBody2D

var object_type 
var list_of_pastries = ["ButterScotchPie", 
						"Donut", 
						"ApricotJelly", 
						"FruitCake", 
						"ExpressoBun", 
						"ChocolateChipCookie", 
						"ButteryBaguette" ]
var recipe
var max_charge_time: float = 3.0
var charge_time = max_charge_time

@onready var food_image = $foodImage
@onready var object 
@onready var main = get_tree().current_scene
@onready var grab = $AudioStreamPlayer2D
var location_of_objects 
var player
const TIME_INCREMENT = 0.016 
func _ready():
	player = get_node("../Player")

	location_of_objects = main.get_node("Ysort")
	$AnimatedSprite2D.visible = false
	
		

			

func _process(delta):
	if charge_time <= 0: 
		_on_grab_zone_area_entered(player)
		$AnimatedSprite2D.visible = false

func find_and_set_sprite(target):
	var path = "res://food/"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if !dir.current_is_dir() and file_name.find(target) != -1:
			print("found!")
			dir.list_dir_end()
			var sprite_path = path + file_name
#			food_image.texture = load(sprite_path)
#			food_image.scale = Vector2(.5,.5)
			break
		
		file_name = dir.get_next()
	
	


func _on_grab_zone_area_entered(area):
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("animate")
	
	if area.name.contains("Order"):
		object_type = area.get_node("Object").objectType

		match object_type:
			"rawSteak":
				object = load("res://raw_steak.tscn")
			"ButterScotchPie": 
				object = load("res://food/ButterScotchPie.tscn")
			"Donut":
				object = load("res://food/Donut.tscn")
			"ApricotJelly":
				object = load("res://food/ApricotJelly.tscn")
			"FruitCake":
				object = load("res://food/FruitCake.tscn")
			"ExpressoBun":
				object = load("res://food/ExpressoBun.tscn")
			"ChocolateChipCookie":
				object = load("res://food/ChocolateChipCookie.tscn")
			"ButteryBaguette":
				object = load("res://food/ButteryBaguette.tscn")
		location_of_objects.remove_child(area)

		
	if charge_time <=0:
		grab.play()
		var my_object = object.instantiate()
		

		var main = get_tree().current_scene
		var temp = main.get_node("Ysort")
		temp.add_child(my_object)
	#	my_object.global_position = self.global_position

		area._on_grab_area_entered(my_object)
		charge_time = 3.0
	


func _on_timer_timeout():
	charge_time -= 1.0
	
#	while true:
#		if $Control/ChargeBar.value > 100:
#			break
#		if ($Control/ChargeBar.value/100) <= ( max_charge_time - charge_time/max_charge_time):
#			print()
#
#			$Control/ChargeBar.value += 1
##
##			print("charging")
#
#			print($Control/ChargeBar.value, " ", 1.0/max_charge_time)



func _on_charge_zone_area_entered(area):
	$Timer.start()
	print("charge starting")


func _on_charge_zone_area_exited(area):
	$Timer.stop()
	print("charging stopped")
	$AnimatedSprite2D.visible = false
