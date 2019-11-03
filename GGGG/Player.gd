extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity: Vector2

var acceleration: Vector2

export var max_movement_speed: int = 600
# FIXME: find better name
export var movement_acceleration: int = 60

export var max_fall_speed: int = 300
export var fall_acceleration: int = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	acceleration = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_input(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		velocity.x = max(min(velocity.x + movement_acceleration, max_movement_speed), -max_movement_speed)
	if Input.is_action_pressed("ui_left"):
		velocity.x = min(max(velocity.x - movement_acceleration, -max_movement_speed), max_movement_speed)
	if !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		if velocity.x > 0:
			velocity.x = max(velocity.x - movement_acceleration, 0)
		else:
			velocity.x = min(velocity.x + movement_acceleration, 0)
			
	velocity.y = min(velocity.y + fall_acceleration, max_fall_speed)
	
	if is_on_floor(): print("ya")
	
func _physics_process(delta: float):
	get_input(delta)
	move_and_slide(velocity, Vector2(0, -1))

