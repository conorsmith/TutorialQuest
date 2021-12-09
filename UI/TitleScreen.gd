extends Node

onready var characterAnimationPlayer = $Character/AnimationPlayer

func _ready():
	characterAnimationPlayer.play("Walk")

func _on_Button_pressed():
	get_tree().change_scene("res://World.tscn")
	queue_free()
