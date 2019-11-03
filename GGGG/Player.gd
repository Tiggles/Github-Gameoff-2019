extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var movement_speed: int = 800
export var max_movement_speed: int = 1000
var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_input() -> void:
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	velocity = velocity.normalized() * movement_speed;

func _physics_process(delta: float):
	get_input()
	move_and_slide(velocity)

