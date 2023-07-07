extends CharacterBody2D
class_name Player


@onready var anim_tree = $AnimationTree
@onready var animation_state = anim_tree.get("parameters/playback")
@onready var grab_box = $pivotPoint/Grab/GrabBox
@onready var my_object = $instancePlaceHolder
@onready var disable_grab_timer = $disable_grab_timer
@onready var main = get_tree().current_scene
#@onready var temp = $ObjectHolder/SpriteLocation


@export var speed = 80
@export var friction = 400
@export var acceleration = 400
@export var roll_speed = 500
@export var dash_finished = true


signal collected (collectable)


const dash_cooldown = 60
var timer = dash_cooldown
var dash_on_cooldown = false
var is_holding_object = false
var holding_plate = false
var current_order
var object
var mouse_left_down: bool = false

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
	$AnimatedSprite2D/HoldItem.visible = false
	$pivotPoint/ChargerZone/ChargerBox.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_holding_object == true:
		$pivotPoint/Grab/GrabBox.disabled = true
	else: holding_plate = false
	#state machine 
	match states:
		WALK:
			walk_state(delta, "walk")
		DASH:
			dash_state(delta,"dash")
		HOLD_PLATE:
			hold_item_state()
		HOLD_ITEM:
			hold_item_state()
		WALK_WITH_PLATE:
			walk_state(delta, "hold_item_walk")
		DASH_WITH_PLATE:
			dash_state(delta,"hold_item_dash")
		WALK_WITH_ITEM:
			walk_state(delta, "hold_item_walk")
		DASH_WITH_ITEM: 
			dash_state(delta, "hold_item_dash")

	if mouse_left_down == true:
		$pivotPoint/ChargerZone/ChargerBox.disabled = false
	else:
		$pivotPoint/ChargerZone/ChargerBox.disabled = true

func hold_plate_state():
	is_holding_object = true
	holding_plate = true
	states = WALK_WITH_PLATE
	$AnimatedSprite2D/HoldItem.visible = true

func hold_item_state():
	is_holding_object = true
	holding_plate = false
	states = WALK_WITH_ITEM
	$AnimatedSprite2D/HoldItem.visible = true

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
		
		if is_holding_object == true and holding_plate == true:
			states = WALK_WITH_PLATE
			animation_state.travel(walk_state)
		if is_holding_object == true and holding_plate == false:
			states = WALK_WITH_ITEM
			animation_state.travel(walk_state)
		if is_holding_object == false:
			states = WALK
			animation_state.travel(walk_state)
			
		velocity = velocity.move_toward(input_dir * speed, acceleration * delta)
	
	elif is_holding_object == true and holding_plate == true:
		animation_state.travel("hold_plate_idle")
		$AnimatedSprite2D/FoodImage.texture = my_object.get_node("ObjectHolder/Sprite2D").texture
#		print($pivotPoint/FoodImage.texture)
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	elif is_holding_object == true and holding_plate == false:
		animation_state.travel("hold_item_idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	elif is_holding_object == false:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		

	move_and_slide()


	if Input.is_action_just_pressed("dash") and dash_finished == true and dash_on_cooldown == false:
		if is_holding_object == true and holding_plate == true:
			states = DASH_WITH_PLATE
		if is_holding_object == true and holding_plate == false:
			states = DASH_WITH_ITEM
		if is_holding_object == false: 
			states = DASH
	
	
	if dash_on_cooldown == true:
		timer -= 1
		
	if timer <= 0:
		timer = dash_cooldown
		dash_on_cooldown = false
	
	if Input.is_action_just_pressed("grab") and is_holding_object == false:
		grab_box.disabled = false
		disable_grab_timer.start()
		

	if Input.is_action_just_pressed("grab") and is_holding_object == true:
#		my_object.get_node("Object").dropoff(self, main)
		drop_item()
	
	
		
		
#	if is_holding_object:
#		print(my_object)ww

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mouse_left_down = true
			print("down")
		elif event.button_index ==1 and not event.is_pressed():
			mouse_left_down = false
			print("up")
			
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
#	grab_box.disabled = true
	grab_box.set_deferred("disabled", true)

func grab_object(area):
	if area.name == "GiveOrder":
		print(area.name)
		area.get_node("GiverOrderBox").set_deferred("disabled", true)
		var order = load("res://food/Order.tscn")
		
		var my_order = order.instantiate()
		print(my_order.get_node("Object"))
		my_order.get_node("Object").objectType = area.owner.my_order
		match area.owner.my_order:
			"ButterScotchPie": 
				object = load("res://food/ButterScotchPie.png")
				my_order.get_node("Note/foodImage").texture = object
				my_order.get_node("Object").set_deferred("objectType", "ButterScotchPie")
			"Donut":
				object = load("res://food/Donut.png")
				my_order.get_node("Note/foodImage").texture = object
				my_order.get_node("Object").set_deferred("objectType", "Donut")
			"ApricotJelly":
				object = load("res://food/ApricotJelly.png")
				my_order.get_node("Note/foodImage").texture = object
				my_order.get_node("Object").set_deferred("objectType", "ApricotJelly")
			"FruitCake":
				object = load("res://food/FruitCake.png")
				my_order.get_node("Note/foodImage").texture = object
				my_order.get_node("Object").set_deferred("objectType", "FruitCake")
			"ExpressoBun":
				object = load("res://food/ExpressoBun.png")
				my_order.get_node("Note/foodImage").texture = object
				my_order.get_node("Object").set_deferred("objectType", "ExpressoBun")
			"ChocolateChipCookie":
				object = load("res://food/ChocolateChipCookies.png")
				my_order.get_node("Note/foodImage").texture = object
				my_order.get_node("Object").set_deferred("objectType", "ChocolateChipCookie")
			"ButteryBaguette":
				object = load("res://food/ButteryBaguette.png")
				my_order.get_node("Note/foodImage").texture = object
				my_order.get_node("Object").set_deferred("objectType", "ButteryBaguette")
		main.add_child(my_order)
		my_order.global_position = $pivotPoint/Grab/dropOffPoint.global_position
		grab_object(my_order)
		
	elif area.name == "Money":
		$MoneySound.play()
		collect(area)
		area.queue_free()
	else:
		my_object = area

		if my_object.get_parent().name !=  "FoodCrate":
			my_object.get_parent().remove_child(my_object)

		if my_object.name != "FoodCrateGrabBox":

			my_object = area

			if my_object.name.contains("Plate") == true:
				$AnimatedSprite2D/Sprite2D.texture = my_object.get_node("ObjectHolder/Sprite2D2").texture
				if my_object.get_node("ObjectHolder").is_holding_object == true:
					$AnimatedSprite2D/FoodImage	.texture =  my_object.get_node("ObjectHolder/Sprite2D/FoodImage").texture
			elif my_object.name.contains("Order") == true:
				$AnimatedSprite2D/Sprite2D.texture = my_object.get_node("Note").texture
			else:
				$AnimatedSprite2D/Sprite2D.texture = my_object.get_node("Sprite2D").texture
			states = HOLD_ITEM
	

func _on_grab_area_entered(area):
	_on_disable_grab_timer_timeout()
	grab_object(area)

func drop_item():
#	my_object.get_node("Object/CollisionShape2D").set_deferred("disabled", false)
	
	main.get_node("Ysort").add_child(my_object)
	
	my_object.global_position = $pivotPoint/Grab/dropOffPoint.global_position
	$AnimatedSprite2D/FoodImage.texture	= null
	$AnimatedSprite2D/Sprite2D.texture = null
	states = WALK
	is_holding_object = false
	holding_plate = false
	my_object = null
	$AnimatedSprite2D/HoldItem.visible = false


func collect(collectable):
	collected.emit(collectable)


