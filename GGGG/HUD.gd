extends MarginContainer

var Heart = preload("res://Heart.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var scoreCounter = null
var heart_shaped_box = null


# Called when the node enters the scene tree for the first time.
func _ready():
	heart_shaped_box = $VBoxContainer/HeartContainer
	scoreCounter = $VBoxContainer/ScoreContainer/ScoreCount

func update_score(score: int):
	scoreCounter.set_text(str(score))
	
func update_life(lifecount: int):
	var children = heart_shaped_box.get_children()
	for heart in children:
		heart_shaped_box.remove_child(heart)
		heart.queue_free()
	
	for _i in range(lifecount):
		var heart = Heart.instance()
		heart_shaped_box.add_child(heart)
