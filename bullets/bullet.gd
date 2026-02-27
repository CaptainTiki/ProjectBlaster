extends Node2D
class_name Bullet

@export var speed : float = 320
@export var damage : float = 1

@onready var animated_sprite_2d: AnimatedSprite2D = $Sprite/AnimatedSprite2D

var velocity: Vector2 = Vector2.ZERO
var pool : BulletPool = null

func _physics_process(delta: float) -> void:
	global_position += velocity * speed * delta
	if global_position.x > 1000 or global_position.x < -1000:
		deactivate()
		pool.return_bullet(self)

func fire_bullet(location : Vector2, direction : Vector2) -> void:
	global_position = location
	velocity = direction

func activate() -> void:
	animated_sprite_2d.play("default")
	set_physics_process(true)
	set_process(true)
	visible = true

func deactivate() -> void:
	animated_sprite_2d.stop()
	global_position = Vector2(-10000, -10000)
	set_physics_process(false)
	set_process(false)
	visible = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("damageable"):
		body.take_damage(damage)
	
	deactivate()
	pool.return_bullet(self)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("damageable"):
		area.take_damage(damage)
	
	deactivate()
	pool.return_bullet(self)
