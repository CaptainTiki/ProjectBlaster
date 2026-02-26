extends CharacterBody2D
class_name PlayerShip

@export_category("movement")
@export var max_speed : float = 450.0
@export var accel : float = 2400.0
@export var decel : float = 1600.0
@export_category("input")
@export var deadzone : float = 0.01

@onready var animated_sprite_2d: AnimatedSprite2D = $ShipSprite/AnimatedSprite2D

var half_screen_size : Vector2 = Vector2.ZERO

func _ready() -> void:
	half_screen_size = get_viewport().get_visible_rect().size / 2

func _physics_process(delta: float) -> void:
	var vel : Vector2 = Vector2.ZERO
	vel.x = Input.get_axis("move_left", "move_right")
	vel.y = Input.get_axis("move_up", "move_down")
	
	if vel.length() <= deadzone:
		velocity = velocity.move_toward(Vector2.ZERO, decel * delta)
		
	velocity += vel * accel * delta
	velocity = velocity.limit_length(max_speed)
	if Input.is_action_just_pressed("fire_primary"):
		pass
	if Input.is_action_just_pressed("fire_secondary"):
		pass
	
	set_sprite()
	move_and_slide()
	
	global_position = global_position.clamp(
		Vector2(-half_screen_size.x, -half_screen_size.y),
		Vector2(half_screen_size.x, half_screen_size.y))

func set_sprite() -> void:
	if velocity.y > deadzone:
		animated_sprite_2d.play("roll_down")
	elif velocity.y < -deadzone:
		animated_sprite_2d.play("roll_up")
	else:
		animated_sprite_2d.play("idle")

func _unhandled_input(event: InputEvent) -> void:
	pass
