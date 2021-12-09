extends KinematicBody2D

enum {
	TURNING,
	DISABLED
}

var state = TURNING
var facing_vector = Vector2.DOWN

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var rotateTimer = $RotateTimer

signal player_wins

func _ready():
	animationTree.active = true
	rotateTimer.start(rand_range(1, 3))

func turn():
	facing_vector = random_new_direction(facing_vector)
	
	animationTree.set("parameters/Idle/blend_position", facing_vector)
	animationState.travel("Idle")

func random_new_direction(exclude_vector):
	var direction_vectors = [
		Vector2(0, 1),
		Vector2(0, -1),
		Vector2(1, 0),
		Vector2(-1, 0),
	]
	
	direction_vectors.erase(exclude_vector)	
	
	direction_vectors.shuffle()
	
	return direction_vectors.pop_front()

func _on_WinZone_area_entered(area):
	state = DISABLED
	
	animationTree.set("parameters/Idle/blend_position", Vector2(0, 1))
	animationState.travel("Idle")
	
	emit_signal("player_wins")


func _on_RotateTimer_timeout():
	if state == TURNING:
		turn()
		rotateTimer.start(rand_range(1, 3))
