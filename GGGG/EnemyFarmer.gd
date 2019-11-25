extends KinematicBody2D

class_name EnemyFarmer

enum { MOVING_LEFT = -1, IN_AIR = 0, MOVING_RIGHT = 1}

export var speed = 200
export (int, 0, 2000) var gravity = 600
export (int, -1, 1) var default_moving_direction_x = MOVING_LEFT

var moving_direction = default_moving_direction_x

var gravity_vec = Vector2(0, 0)
var velocity = Vector2(0, 0)
var floorNormal = Vector2(0, -1) # floor is down

onready var anime = $AnimatedSprite


func _ready():
	gravity_vec.y = gravity
	anime.animation = "walk"
	anime.flip_h = default_moving_direction_x < 0


func _physics_process(delta: float) -> void:
	velocity += gravity_vec * delta
	var _linear_velocity = move_and_slide(velocity, floorNormal)

	if self.is_on_wall():
		self.moving_direction = -1 * self.moving_direction
		anime.flip_h = !anime.flip_h
		
	if self.is_on_floor():
		self.velocity.x = self.speed * self.moving_direction

