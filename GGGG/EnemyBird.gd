extends KinematicBody2D

export (int) var speed = 75

enum { MOVING_LEFT = -1, MOVING_RIGHT = 1}
export (int, -1, 1) var default_moving_direction_x = MOVING_LEFT

var velocity = Vector2(0, 0)
var floor_normal = Vector2(0, -1)
onready var sprite = $Sprite

func _ready():
	velocity.x = default_moving_direction_x * speed
	sprite.flip_h = default_moving_direction_x > 0

func flip_the_bird():
	sprite.flip_h = !sprite.flip_h
	velocity.x *= -1

func _physics_process(_delta: float) -> void:
	var _next_pos = move_and_slide(velocity, floor_normal) # according to docs delta is used inside move_and_slide so no need to include it
	if is_on_wall(): flip_the_bird()

