extends CharacterBody2D

#@onready var anim_tree = $AnimationTree
#@onready var animation_state = anim_tree.get("parameters/playback")
@onready var grab_box = $pivotPoint/Grab/GrabBox
@onready var my_object = $instancePlaceHolder
@onready var disable_grab_timer = $disable_grab_timer
@onready var main = get_tree().current_scene
@onready var animated_sprite = $AnimatedSprite2D
#@onready var temp = $ObjectHolder/SpriteLocation


@export var speed = 80
@export var friction = 400
@export var acceleration = 400
@export var roll_speed = 500
@export var dash_finished = true

var list_of_pastries = ["ButterScotchPie", 
						"Donut", 
						"ApricotJelly", 
						"FruitCake", 
						"ExpressoBun", 
						"ChocolateChipCookie", 
						"ButteryBaguette" ]


# Called when the node enters the scene tree for the first time.
enum { 
	FOllOW,
	IDLE

}
var states = IDLE
var input_dir = Vector2.ZERO
var roll_dir = Vector2.DOWN
var my_order
var object
var my_waiting_spot 
var facing_dir = Vector2.ZERO
var have_order = false
var wait_time: float = 6
var patience: String
var begin_waiting = false
func _ready():
	
	my_order = list_of_pastries.pick_random()
	match my_order:
		"ButterScotchPie": 
			object = load("res://food/ButterScotchPie.png")
		"Donut":
			object = load("res://food/Donut.png")
		"ApricotJelly":
			object = load("res://food/ApricotJelly.png")
		"FruitCake":
			object = load("res://food/FruitCake.png")
		"ExpressoBun":
			object = load("res://food/ExpressoBun.png")
		"ChocolateChipCookie":
			object = load("res://food/ChocolateChipCookies.png")
		"ButteryBaguette":
			object = load("res://food/ButteryBaguette.png")
	$Sprite2D.visible = true
	$Sprite2D/FoodImage.texture = object
	
	
	
func _physics_process(delta):
#	if begin_waiting == true:
#
#		begin_waiting = false
	match states:
		FOllOW: 
			go_to_waiting_spot()
		IDLE: 
			wait()
			if (wait_time >= 24):
				$WaitBar.play("Patience1")
				patience = "very happy"
			elif (wait_time >= 18):
				$WaitBar.play("Patience2")
				patience = "happy"
			elif (wait_time >= 12):
				$WaitBar.play("Patience3")
				patience = "content"
			elif (wait_time >= 6):
				$WaitBar.play("Patience4")
				patience = "unhappy"
			elif (wait_time > 0):
				$WaitBar.play("Patience5")
				patience = "mad"
			if wait_time == 0: 
				$WaitBar.play("out_of_patience")
				patience = "very mad"
				
			elif wait_time <0:
				await $WaitBar.animation_finished
				leave(patience)
#	if velocity.x > 0:
#		$AnimatedSprite2D.play("walk_right")
#	elif velocity.x < 0:
#		$AnimatedSprite2D.play("walk_left")
#
#	if velocity.y > 0:
#		$AnimatedSprite2D.play("walk_down")
#	elif velocity.y < 0:
#		$AnimatedSprite2D.play("walk_up")
	var animation_playing = animated_sprite.animation
	var new_animation = ""

	if velocity.x > 0:
		new_animation = "walk_right"
		facing_dir = Vector2(1,0)
	if velocity.x < 0:
		new_animation = "walk_left"
		facing_dir = Vector2(-1,0)
	if velocity.y > 0:
		new_animation = "walk_down"
		facing_dir = Vector2(0,-1)
	if velocity.y < 0:
		new_animation = "walk_up"
		facing_dir = Vector2(0,1)

	if new_animation != animation_playing:
		animated_sprite.play(new_animation)
		
		
func leave(patience_level):
	match patience_level:
		"very happy":
			$WaitBar.play("leave_very_happy")
		"happy":
			$WaitBar.play("leave_happy")
		"content":
			$WaitBar.play("leave_content")
		"unhappy":
			$WaitBar.play("leave_unhappy")
		"mad":
			$WaitBar.play("leave_mad")
		"very mad":
			$WaitBar.play("leave_very_mad")
			
func _on_area_2d_area_entered(area):
	
#	print("area ", area, " detected")

	if area.owner.occupied == false and my_waiting_spot == null:
		
		my_waiting_spot = area
		states = FOllOW
		$Area2D/DetectWaitingArea.set_deferred("disabled", true)
		area.owner.occupied = true
	
		
func wait():
	velocity = velocity.move_toward(Vector2(0,0), 500)
	if facing_dir == Vector2(1,0):
		animated_sprite.play("idle_right")
	if facing_dir == Vector2(-1,0):
		animated_sprite.play("idle_left")
	if facing_dir == Vector2(0,-1):
		animated_sprite.play("idle_down")
	if facing_dir == Vector2(0,1):
		animated_sprite.play("idle_up")
	move_and_slide()
	begin_waiting = true


func go_to_waiting_spot():

	var target_location = ((my_waiting_spot.global_position - self.global_position)).normalized()
	velocity = velocity.move_toward(target_location * speed , 200)
	move_and_slide()
	
	var distance_to_target = (my_waiting_spot.global_position - self.global_position).length()

	if distance_to_target <= 1:
		states = IDLE


func _on_timer_timeout():
	wait_time -= 1
	print("finished")
#	$Timer.start(-1)
