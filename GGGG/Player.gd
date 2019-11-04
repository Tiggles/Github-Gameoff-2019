extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# General movement
var velocity: Vector2
export var max_movement_speed: int = 600
# FIXME: find better name
export var movement_acceleration: int = 60
export var max_fall_speed: int = 500
export var fall_acceleration: int = 60
var moving_left = false

# Jumping
var can_jump: bool = false
export var jump_velocity: int = 1200
var can_wall_jump = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_input(delta: float) -> void:
	# Is touching wall or floor
	var is_touching = self.is_on_floor() or self.is_on_wall()
	
	var curr_mvmt_accl = movement_acceleration if is_touching else movement_acceleration / 2
	can_wall_jump = self.is_on_wall() and !self.is_on_floor()
	
	
	if is_on_ceiling():
		self.velocity.y = 1
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = max(min(velocity.x + curr_mvmt_accl, max_movement_speed), -max_movement_speed)
	if Input.is_action_pressed("ui_left"):
		velocity.x = min(max(velocity.x - curr_mvmt_accl, -max_movement_speed), max_movement_speed)
	if !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
		if velocity.x > 0:
			velocity.x = max(velocity.x - curr_mvmt_accl, 0)
		else:
			velocity.x = min(velocity.x + curr_mvmt_accl, 0)
			
	velocity.y = min(velocity.y + fall_acceleration, max_fall_speed)
	
	if Input.is_action_pressed("ui_up"):
		if can_wall_jump and velocity.x != 0:
			if moving_left:
				velocity.y = -jump_velocity * 0.8
				velocity.x = 900
			else:
				velocity.y = -jump_velocity * 0.8
				velocity.x = -900
		elif can_jump:
			velocity.y = -jump_velocity
	
	# standard jumping or wall jump
	if is_touching:
		can_jump = true
	else:
		can_jump = false
		
	moving_left = velocity.x < 0
	
func _physics_process(delta: float):
	get_input(delta)
	# delta is applied inside function
	move_and_slide(velocity, Vector2(0, -1))

