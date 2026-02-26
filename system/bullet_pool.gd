extends Node
class_name BulletPool

@onready var bullet_parent: Node2D = $BulletParent

const BULLET_BASE = preload("uid://oqsguvuv58ba")
var sm_bullets : Array[Bullet] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_bullet_pools()


func fill_bullet_pools() -> void:
	for i in 120:
		var new_bullet : Bullet = BULLET_BASE.instantiate()
		new_bullet.ready_for_pool(bullet_parent)
		sm_bullets.append(new_bullet)
