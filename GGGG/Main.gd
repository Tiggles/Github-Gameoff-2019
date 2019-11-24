extends Node2D

class_name Main

onready var hud = $CanvasLayer/HUD


func _ready():
	hud.update_life($Player.health)

func _on_Player_damage_taken(health: int) -> void:
	hud.update_life(health)

func _on_Player_gem_collected(collected):
	hud.update_score(collected)
