extends StaticBody2D

var have_food = false
var timer = Timer.new()
var elapsed_time = 0

@onready var cook_timer = $CookTime

# Called when the node enters the scene tree for the first time.


func _ready():
	cook_timer.timeout.connect(_on_timer_timeout)
	cook_timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_timer_timeout():
	print("timer finished")
