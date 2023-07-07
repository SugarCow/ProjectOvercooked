extends Node2D

@export var player: Player
@export var ui:PlayerUI
# Called when the node enters the scene tree for the first time.
func _ready():
	$Ysort/mug.play("animate")
	if !player.collected.is_connected(ui.is_connected):
		player.collected.connect(ui._on_collected)


