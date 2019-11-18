extends Node2D

export (PackedScene) var Heart

func _ready():
	pass # Replace with function body.

func _on_Player_coin_picked(count: int) -> void:
	$CanvasLayer/HUD/HBoxContainer/Bars/VBoxContainer/CoinCount.text = str(count)

func _on_Player_damage_taken(health: int):
	pass
