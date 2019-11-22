extends KinematicBody2D

export var speed = 10
var speed_factor = 500

enum { MOVING_LEFT = -1, MOVING_RIGHT = 1}
enum { MOVING_DOWN = -1, MOVING_UP = 1}
export var default_moving_direction_x = MOVING_RIGHT
var moving_direction_x = default_moving_direction_x
var moving_direction_y = MOVING_DOWN
var time_start = 0
var time_now = 0


var velocity = Vector2(0, 0)

func _ready():
	var time_start = OS.get_unix_time()

func _physics_process(delta: float) -> void:
	time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	var collision = move_and_slide(velocity * delta)

	if (elapsed % 2 == 0):
		var player = get_tree().get_root().get_node("Main").get_node("Player")
		if (player.position.x < self.position.x):
			$Sprite.flip_h = false
			self.moving_direction_x = MOVING_LEFT
		else:
			$Sprite.flip_h = true
			self.moving_direction_x = MOVING_RIGHT
	
		if (player.position.y < self.position.y):
			self.moving_direction_y = MOVING_DOWN
		else:
			self.moving_direction_y = MOVING_UP

	
		self.velocity.x = speed * speed_factor * moving_direction_x
		self.velocity.y = speed * speed_factor * moving_direction_y
