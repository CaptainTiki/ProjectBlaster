extends Node2D
class_name Level

const PLAYER_SHIP = preload("uid://n2c0nbin73lm")

var player_ship : PlayerShip = null

func _ready() -> void:
	player_ship = PLAYER_SHIP.instantiate() as PlayerShip
	add_child(player_ship)
	
