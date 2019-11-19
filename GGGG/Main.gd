extends Node2D

export (PackedScene) var Heart


func _on_Player_damage_taken(health: int):
	pass

func _on_Player_gem_collected(gem_count: int) -> void:
	$CanvasLayer/HUD/HBoxContainer/Bars/VBoxContainer/GemCount.text = str(gem_count)
