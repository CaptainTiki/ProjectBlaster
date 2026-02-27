extends CharacterBody2D
class_name PlayerShip

@export_category("movement")
@export var max_speed : float = 450.0
@export var accel : float = 2400.0
@export var decel : float = 1600.0
@export_category("weapon")
@export var primary_fire_delay : float = 0.025
@export var collision_damage : float = 23
@export_category("health")
@export var max_health : float = 100
@export_category("input")
@export var deadzone : float = 0.01


@onready var animated_sprite_2d: AnimatedSprite2D = $ShipSprite/AnimatedSprite2D

var half_screen_size : Vector2 = Vector2.ZERO
var bullet_pool : BulletPool = null
var primary_fire_timer : float = 0
var health : float = 0

func _ready() -> void:
	health = max_health
	half_screen_size = get_viewport().get_visible_rect().size / 2

func _physics_process(delta: float) -> void:
	var vel : Vector2 = Vector2.ZERO
	vel.x = Input.get_axis("move_left", "move_right")
	vel.y = Input.get_axis("move_up", "move_down")
	
	if vel.length() <= deadzone:
		velocity = velocity.move_toward(Vector2.ZERO, decel * delta)
		
	velocity += vel * accel * delta
	velocity = velocity.limit_length(max_speed)
	
	primary_fire_timer -= delta
	if Input.is_action_pressed("fire_primary"):
		fire_cannon(delta)
	if Input.is_action_just_pressed("fire_secondary"):
		pass
	
	set_sprite()
	move_and_slide()
	
	global_position = global_position.clamp(
		Vector2(-half_screen_size.x, -half_screen_size.y),
		Vector2(half_screen_size.x, half_screen_size.y))

func fire_cannon(delta: float) -> void:
	if primary_fire_timer > 0:
		return
	primary_fire_timer = primary_fire_delay
	
	var new_bullet : Bullet = bullet_pool.get_bullet() as Bullet
	if new_bullet:
		new_bullet.activate()
		new_bullet.global_position = %WeaponMuzzle.global_position
		new_bullet.velocity = Vector2(1,0)

func kill_player() -> void:
	print("kill player")
	pass

func take_damage(amt : float) -> void:
	health -= amt
	if health <= 0:
		kill_player()

func set_sprite() -> void:
	if velocity.y > deadzone:
		animated_sprite_2d.play("roll_down")
	elif velocity.y < -deadzone:
		animated_sprite_2d.play("roll_up")
	else:
		animated_sprite_2d.play("idle")

func set_bullet_pool(bp : BulletPool) -> void:
	bullet_pool = bp

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("damageable"):
		area.take_damage(collision_damage)
		take_damage(area.collision_damage)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("damageable"):
		body.take_damage(collision_damage)
