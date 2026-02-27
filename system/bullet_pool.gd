extends Node
class_name BulletPool

@onready var bullet_parent: Node2D = $BulletParent

const BULLET_BASE = preload("uid://oqsguvuv58ba")
var sm_bullets : Array[Bullet] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_bullet_pools()
	print(sm_bullets.size())

func get_bullet() -> Bullet:
	var new_bullet : Bullet
	if sm_bullets.size() > 0:
		new_bullet = sm_bullets.pop_back()
	return new_bullet

func return_bullet(bullet : Bullet) -> void:
	sm_bullets.push_back(bullet)

func fill_bullet_pools() -> void:
	for i in 120:
		var new_bullet : Bullet = BULLET_BASE.instantiate()
		bullet_parent.add_child(new_bullet)
		new_bullet.pool = self
		new_bullet.deactivate()
		sm_bullets.append(new_bullet)
