extends Area2D

@onready var raw = load("res://assets/Ghostpixxells_pixelfood/rawSteak.png")
@onready var cooked = load("res://assets/Ghostpixxells_pixelfood/95_steak.png")
@onready var burnt = load("res://assets/Ghostpixxells_pixelfood/burnSteak.png")
@onready var is_raw = true
@onready var is_cooked = false
@onready var is_burnt = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.owner != null:
		print(self.owner.name)
	if is_cooked == true and is_burnt == false: 
		$Sprite2D.texture = cooked
	elif is_cooked == true and is_burnt == true: 
		$Sprite2D.texture = burnt
	else: 
		$Sprite2D.texture = raw
