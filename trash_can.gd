extends StaticBody2D


# Called when the node enters the scene tree for the first time.



func _on_drop_off_box_area_entered(area):
		print(area.name)
		area.queue_free()
		$AnimatedSprite2D.play("default")

