extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var animation_state = anim_tree.get("parameters/playback")
@onready var grab_box = $pivotPoint/Grab/GrabBox
@onready var my_object = $instancePlaceHolder

@export var speed = 80
@export var friction = 400
@export var acceleration = 400
@export var roll_speed = 500
@export var dash_finished = true

const dash_cooldown = 60
var timer = dash_cooldown
var dash_on_cooldown = false
var hands_full = false
# Called when the node enters the scene tree for the first time.
enum { 
	WALK,
	HOLD_PLATE,
	DASH
}
var states = WALK
var input_dir = Vector2.ZERO
var roll_dir = Vector2.DOWN


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match states:
		WALK:
			walk_state(delta)
		DASH:
			dash_state(delta)
		HOLD_PLATE:
			hold_plate_state()
			
func hold_plate_state():
	hands_full = true
	states = WALK
	
	
func walk_state(delta):

	input_dir = Vector2(Input.get_action_raw_strength("ui_right") - Input.get_action_strength("ui_left"), 
						Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
						
	input_dir = input_dir.normalized()
	roll_dir = input_dir
	
	if input_dir != Vector2.ZERO:
		anim_tree.set("parameters/idle/blend_position", input_dir)
		anim_tree.set("parameters/walk/blend_position", input_dir)
		anim_tree.set("parameters/dash/blend_position", input_dir)
		anim_tree.set("parameters/hold_plate_idle/blend_position", input_dir)
		animation_state.travel("walk")
		velocity = velocity.move_toward(input_dir * speed, acceleration * delta)
	
	elif hands_full == true:
		animation_state.travel("hold_plate_idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	else:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		

	move_and_slide()
	
		
	if Input.is_action_just_pressed("dash") and dash_finished == true and dash_on_cooldown == false:
		states = DASH
	if dash_on_cooldown == true:
		timer -= 1
		
	if timer <= 0:
		timer = dash_cooldown
		dash_on_cooldown = false
	
	if Input.is_action_just_pressed("grab") and hands_full == false:
		grab_box.disabled = false
		print("grabbing")
	if Input.is_action_just_pressed("grab") and hands_full == true:
		print(my_object)
		my_object.get_node("Object").dropoff()
		hands_full = false
		
#	if hands_full:
#		print(my_object)
		
func dash_state(delta):
	velocity = velocity.move_toward(roll_dir * roll_speed, 800)
	animation_state.travel("dash")
	move_and_slide()
	dash_finished = false
	dash_on_cooldown = true


	
func dash_animation_finished(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 2000 )
	move_and_slide()
	states = WALK
	dash_finished = true
	
	
	
