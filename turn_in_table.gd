extends StaticBody2D

@onready var anim = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("animate")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
