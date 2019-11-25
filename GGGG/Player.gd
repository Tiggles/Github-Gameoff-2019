extends KinematicBody2D

class_name Player # you can use is Player to check if a unknown object is a Player

# Signals
signal damage_taken(damage_count)
signal health_received
signal gem_collected(gem_count)

# Stats
export (int) var health = 5
var gem_count = 0
var can_take_damage = true

# General movement
var velocity: Vector2
export var max_movement_speed: int = 600
# FIXME: find better name
export var horizontal_acceleration: int = 40
export(float, 0, 0.9999) var horizontal_deceleration_factor: float = 0.9 
	# closer to 1 -> more momentum is preserved = slower deccelaration
	# zero = instant stop
export var max_fall_speed: int = 600
export var fall_acceleration: int = 30
export(int, 0) var max_midair_jumps: int = 1


enum { MOVING_LEFT = -1, MOVING_INPLACE = 0, MOVING_RIGHT = 1 }
var horizontal_moving_direction = 0 # negative => left, zero 0 => halt, positive => right

var midair_boost = 550
var current_jumps = 0

# Jumping
export var jump_velocity: int = 800
# Intended to be upgradeable
export var jump_factor: int = 1

var boost_up: bool = false
var floor_normal = Vector2(0, -1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_input(_delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		horizontal_moving_direction = MOVING_RIGHT
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		horizontal_moving_direction = MOVING_LEFT
		$Sprite.flip_h = true
	elif not (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		horizontal_moving_direction = MOVING_INPLACE
	
	boost_up = Input.is_action_just_pressed("ui_jump")


func update_movement_parameters(_delta: float) -> void:
	if is_on_ceiling():
		self.velocity.y = 1

	if horizontal_moving_direction == MOVING_RIGHT:
		velocity.x = max(min(velocity.x + horizontal_acceleration, -max_movement_speed), max_movement_speed)
	elif horizontal_moving_direction == MOVING_LEFT:
		velocity.x = min(max(velocity.x - horizontal_acceleration, max_movement_speed), -max_movement_speed)
	else:
		# stopping -> deceleration by a fraction of the current velocity
		velocity.x = velocity.x * horizontal_deceleration_factor

		# claps
		if velocity.x < 0:
			velocity.x = min(velocity.x, 0)
		elif velocity.x > 0:
			velocity.x = max(velocity.x, 0)

	velocity.y = min(velocity.y + fall_acceleration, max_fall_speed)

	if !self.is_on_floor() and boost_up and current_jumps < max_midair_jumps:
		# midair jump
		velocity.y = (-midair_boost) * jump_factor
		current_jumps += 1
	elif self.is_on_floor():
		# normal bounce off the floor
		velocity.y = -jump_velocity * jump_factor
		current_jumps = 0


func _physics_process(delta: float):
	get_input(delta)
	check_exit()
	update_movement_parameters(delta)
	# delta is applied inside function
	var _c = move_and_slide(velocity, floor_normal)
	handle_collisions()


func handle_collisions() -> void:
	for i in get_slide_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		# FIXME There has to be more elegant way of handling collisions
		# e.g. going by masks instead? Or connecting? Groups?
		match collision.collider.name:
			"TileMap":
				$AnimationPlayer.play("ground_collision")
				
				
func got_rectd():
	if can_take_damage and health > 0:
		health -= 1
		$DamageCountDown.start(-1)
		emit_signal("damage_taken", health)
		can_take_damage = false

func collected_gem():
	gem_count += 1
	self.emit_signal("gem_collected", gem_count)


func check_exit() -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_DamageCountDown_timeout():
	can_take_damage = true


func _on_TopField_body_entered(body):
	if body is EnemyFarmer:
		got_rectd()


func _on_BodyField_body_entered(body):
	pass # Replace with function body.


func _on_PogoStickField_body_entered(body):
	if body is EnemyFarmer:
		collected_gem()
