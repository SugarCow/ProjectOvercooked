extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuStove.play("animate")
	$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	
	$Delay.start()
	await $Delay.timeout
	get_tree().change_scene_to_file("res://world.tscn")
	$Music.stop()
	self.queue_free()


func _on_quit_pressed():
	get_tree().quit()
	


func _on_play_mouse_entered():
	pass # Replace with function body.


func _on_settings_pressed():
	
	pass # Replace with function body.


func _on_play_button_down():
	$ButtonDown.play()

func _on_play_button_up():
	$ButtonUp.play()
