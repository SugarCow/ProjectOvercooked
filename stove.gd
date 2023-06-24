extends StaticBody2D

var have_food = false
var timer = Timer.new()
var elapsed_time = 0
@onready var anim = $AnimatedSprite2D
@onready var cook_timer = $CookTime

# Called when the node enters the scene tree for the first time.


func _ready():
	cook_timer.timeout.connect(_on_timer_timeout)
	
	anim.play("animate")


	
func _on_timer_timeout():
	if $ObjectHolder.my_object != null:
		print($ObjectHolder.my_object)
		$ObjectHolder.my_object.get_node("Object").cook_time += 1
		print($ObjectHolder.my_object.get_node("Object").cook_time)
