extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var audioStreamPlayer = $AudioStreamPlayer

signal health_pack_picked_up

func _ready():
	animationPlayer.play("Float")

func _on_PlayerDetectionZone_body_entered(body):
	body.increase_health()
	audioStreamPlayer.play()
	visible = false

func _on_AudioStreamPlayer_finished():
	queue_free()
