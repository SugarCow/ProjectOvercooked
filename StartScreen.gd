extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	$AnimatedSprite2D2.play("animate")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _input(event):
	if event is InputEventMouseButton:
		get_tree().change_scene_to_file("res://menu.tscn")