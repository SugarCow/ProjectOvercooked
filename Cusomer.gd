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




const dash_cooldown = 60
var timer = dash_cooldown
var dash_on_cooldown = false
var is_holding_object = false
var holding_plate = false
var my_waiting_spot 
var facing_dir = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
enum { 
	FOllOW,
	IDLE

}
var states = IDLE
var input_dir = Vector2.ZERO
var roll_dir = Vector2.DOWN
func _physics_process(delta):
	match states:
		FOllOW: 
			go_to_waiting_spot()
		IDLE: 
			wait()
			
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
		facing_dir = Vector2(0,1)
	if velocity.y < 0:
		new_animation = "walk_up"
		facing_dir = Vector2(0,-1)

	if new_animation != animation_playing:
		animated_sprite.play(new_animation)
		
		
func _on_area_2d_area_entered(area):
	
#	print("area ", area, " detected")
	print(area.owner.occupied)
	if area.owner.occupied == false and my_waiting_spot == null:
		
		my_waiting_spot = area
		states = FOllOW
		$Area2D/DetectWaitingArea.set_deferred("disabled", true)
		area.owner.occupied = true
		print(my_waiting_spot.global_position)
		
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
	
func go_to_waiting_spot():

	var target_location = ((my_waiting_spot.global_position - self.global_position)).normalized()
	velocity = velocity.move_toward(target_location * speed , 200)
	move_and_slide()
	
	var distance_to_target = (my_waiting_spot.position - self.position).length()
	print(distance_to_target)
	if distance_to_target <= 1:
		states = IDLE
