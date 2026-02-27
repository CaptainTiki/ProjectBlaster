extends Area2D
class_name AsteroidLarge

@export var move_speed : float = 80
@export var rotate_speed : float = 2
@export var max_health : float = 10
@export var max_chunks : int = 3
@export var collision_damage : float = 12.3

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

const ASTEROID_SMALL = preload("uid://cr3habtd6anlg")

var health = 0
var rotate_amt = 0

var flash_tween: Tween

func _ready() -> void:
	health = max_health
	rotate_amt = randf_range(-rotate_speed, rotate_speed)
	

func _physics_process(delta: float) -> void:
	rotate(rotate_amt * delta)
	global_position.x -= move_speed * delta
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
	for i in randf_range(1, max_chunks):
		spawn_chunk()
	sprite.play("explode")
	sprite.connect("animation_finished",destroy)


func spawn_chunk() -> void:
	var new_chunk : AsteroidSmall = ASTEROID_SMALL.instantiate() as AsteroidSmall
	add_sibling(new_chunk)
	new_chunk.global_position = global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
	new_chunk.velocity = Vector2(randf_range(-100, 100),randf_range(-100, 100))

func destroy(gain_points : bool = true) -> void:
	if not gain_points:
		queue_free()
	else:
		#TODO: add points on asteroid kill?
		queue_free()
