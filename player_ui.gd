extends CanvasLayer
class_name PlayerUI

@onready var coin_label = $Control/MarginContainer/VBoxContainer/Coin2

var coin = 0:
	set(new_coin_value):
		coin = new_coin_value
		_update_coin_lable()

func _ready():
	_update_coin_lable()

func _update_coin_lable():
	coin_label.text =  str(coin)

func _on_collected(collectable) -> void: #this is a void function
	if collectable: 
		coin += 1.50
	
