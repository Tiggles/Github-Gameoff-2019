extends Node2D

export (PackedScene) var Heart

func _ready():
	$CanvasLayer/HUD.update_life($Player.get_health())

func _on_Player_damage_taken(health: int) -> void:
	$CanvasLayer/HUD.update_life(health)

func _on_Player_gem_collected(gem_count: int) -> void:
	$CanvasLayer/HUD.update_score(gem_count)