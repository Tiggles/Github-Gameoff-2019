extends Area2D

class_name Gem

var taken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("bling")

func _on_Gem_body_entered(body):
	if not taken and body is Player:
		body.collected_gem()
		taken = true
		hide()
