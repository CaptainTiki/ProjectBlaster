extends Node2D
class_name Bullet

@export var speed : float = 80
@export var damage : float = 6.5

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += velocity * speed * delta

func fire_bullet(location : Vector2, direction : Vector2) -> void:
	global_position = location
	velocity = direction

func pop_from_pool(parent_node : Node2D) -> void:
	reparent(parent_node)
	set_physics_process(true)
	set_process(true)
	visible = true

func push_to_pool(parent_node : Node2D) -> void:
	reparent(parent_node)
	global_position = Vector2(-10000, -10000)
	set_physics_process(false)
	set_process(false)
	visible = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("damageable"):
		area.take_damage(damage)
