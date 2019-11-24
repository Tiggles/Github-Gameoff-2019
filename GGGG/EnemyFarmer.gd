extends KinematicBody2D

class_name EnemyFarmer

export var speed = 10
var speed_factor = 100

enum { MOVING_LEFT = -1, IN_AIR = 0, MOVING_RIGHT = 1}
export var default_moving_direction = MOVING_RIGHT
var moving_direction = default_moving_direction

var velocity = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = "walk"
	
	if default_moving_direction == MOVING_LEFT:
		$AnimatedSprite.flip_h = true


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.normal.y < 0:
			if self.moving_direction == IN_AIR:
				self.moving_direction = self.default_moving_direction
		else:
			match self.moving_direction:
				MOVING_RIGHT:
					self.moving_direction = MOVING_LEFT
					$AnimatedSprite.flip_h = true
				MOVING_LEFT:
					self.moving_direction = MOVING_RIGHT
					$AnimatedSprite.flip_h = false

			
		self.velocity.x = self.speed * self.speed_factor * self.moving_direction
	else:
		# In air
		self.moving_direction = IN_AIR
		self.velocity.x = 0
		self.velocity.y = 50
