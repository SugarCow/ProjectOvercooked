extends CharacterBody2D

@onready var anim_tree = $AnimationTree
@onready var animation_state = anim_tree.get("parameters/playback")
@onready var grab_box = $pivotPoint/Grab/GrabBox
@onready var my_object = $instancePlaceHolder
@onready var disable_grab_timer = $disable_grab_timer

@export var speed = 80
@export var friction = 400
@export var acceleration = 400
@export var roll_speed = 500
@export var dash_finished = true

const dash_cooldown = 60
var timer = dash_cooldown
var dash_on_cooldown = false
var hands_full = false
var holding_plate = false
# Called when the node enters the scene tree for the first time.
enum { 
	WALK,
	HOLD_PLATE,
	HOLD_ITEM,
	DASH,
	WALK_WITH_PLATE,
	DASH_WITH_PLATE,
	WALK_WITH_ITEM, 
	DASH_WITH_ITEM
}
var states = WALK
var input_dir = Vector2.ZERO
var roll_dir = Vector2.DOWN


func _ready():
	disable_grab_timer.timeout.connect(_on_disable_grab_timer_timeout)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hands_full == true:
		$pivotPoint/Grab/GrabBox.disabled = true
	match states:
		WALK:
			walk_state(delta, "walk")
		DASH:
			dash_state(delta,"dash")
		HOLD_PLATE:
			hold_plate_state()
		HOLD_ITEM:
			hold_item_state()
		WALK_WITH_PLATE:
			walk_state(delta, "hold_plate_walk")
		DASH_WITH_PLATE:
			dash_state(delta,"hold_plate_dash")
		WALK_WITH_ITEM:
			walk_state(delta, "hold_item_walk")
		DASH_WITH_ITEM: 
			dash_state(delta, "hold_item_dash")



func hold_plate_state():
	hands_full = true
	holding_plate = true
	states = WALK_WITH_PLATE

func hold_item_state():
	hands_full = true
	holding_plate = false
	states = WALK_WITH_ITEM
	
	
func walk_state(delta, walk_state):

	input_dir = Vector2(Input.get_action_raw_strength("ui_right") - Input.get_action_strength("ui_left"), 
						Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
						
	input_dir = input_dir.normalized()
	roll_dir = input_dir
	
	if input_dir != Vector2.ZERO:
		anim_tree.set("parameters/idle/blend_position", input_dir)
		anim_tree.set("parameters/walk/blend_position", input_dir)
		anim_tree.set("parameters/dash/blend_position", input_dir)
		anim_tree.set("parameters/hold_plate_idle/blend_position", input_dir)
		anim_tree.set("parameters/hold_plate_walk/blend_position", input_dir)
		anim_tree.set("parameters/hold_plate_dash/blend_position", input_dir)
		anim_tree.set("parameters/hold_item_idle/blend_position", input_dir)
		anim_tree.set("parameters/hold_item_walk/blend_position", input_dir)
		anim_tree.set("parameters/hold_item_dash/blend_position", input_dir)
		
		
		if hands_full == true and holding_plate == true:
			states = WALK_WITH_PLATE
			animation_state.travel(walk_state)
		if hands_full == true and holding_plate == false:
			states = WALK_WITH_ITEM
			animation_state.travel(walk_state)
		if hands_full == false:
			states = WALK
			animation_state.travel(walk_state)
			
		velocity = velocity.move_toward(input_dir * speed, acceleration * delta)
	
	elif hands_full == true and holding_plate == true:
		animation_state.travel("hold_plate_idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	elif hands_full == true and holding_plate == false:
		animation_state.travel("hold_item_idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	elif hands_full == false:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		

	move_and_slide()
	
		
	if Input.is_action_just_pressed("dash") and dash_finished == true and dash_on_cooldown == false:
		if hands_full == true and holding_plate == true:
			states = DASH_WITH_PLATE
		if hands_full == true and holding_plate == false:
			states = DASH_WITH_ITEM
		if hands_full == false: 
			states = DASH
	
	
	if dash_on_cooldown == true:
		timer -= 1
		
	if timer <= 0:
		timer = dash_cooldown
		dash_on_cooldown = false
	
	if Input.is_action_just_pressed("grab") and hands_full == false:
		grab_box.disabled = false
		print("grabbing")
		disable_grab_timer.start()
		
		
	if Input.is_action_just_pressed("grab") and hands_full == true:
		my_object.get_node("Object").dropoff()

	
#	if hands_full:
#		print(my_object)ww
		
func dash_state(delta, dash_state):
	velocity = velocity.move_toward(roll_dir * roll_speed, 800)
	animation_state.travel(dash_state)
	move_and_slide()
	dash_finished = false
	dash_on_cooldown = true


	
func dash_animation_finished(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 2000 )
	move_and_slide()
	states = WALK
	dash_finished = true
	
	
	
	
func _on_disable_grab_timer_timeout():
	grab_box.disabled = true
	

