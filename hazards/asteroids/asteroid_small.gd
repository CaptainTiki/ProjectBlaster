extends Area2D
class_name AsteroidSmall

@export var move_speed : float = 80
@export var rotate_speed : float = 2
@export var max_health : float = 10
@export var collision_damage : float = 8.5

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

var health = 0
var rotate_amt = 0
var velocity : Vector2 = Vector2.ZERO
var friction : float = 1

var flash_tween: Tween

func _ready() -> void:
	health = max_health
	rotate_amt = randf_range(-rotate_speed, rotate_speed)
	

func _physics_process(delta: float) -> void:
	rotate(rotate_amt * delta)
	global_position.x -= move_speed * delta
	global_position += velocity * delta
	velocity = velocity.lerp(Vector2.ZERO, friction * delta) 
	if global_position.x < -1000:
		destroy(false)


func take_damage(amt : float) -> void:
	if flash_tween:
		flash_tween.kill()
		
	health -= amt
	if health <= 0:
		kill_asteroid()
	else:
		flash_tween = create_tween()
		flash_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		sprite.modulate = Color(10, 10, 10, 1)
		flash_tween.tween_property(sprite, "modulate", Color(1,1,1,1), 0.05)

func kill_asteroid() -> void:
	collider.set_disabled(true)
	collision_layer = 0
	rotate_amt = 0
	sprite.play("explode")
	sprite.connect("animation_finished",destroy)

func destroy(gain_points : bool = true) -> void:
	if not gain_points:
		queue_free()
	else:
		#TODO: add points on asteroid kill?
		queue_free()
