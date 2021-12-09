extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK,
	DISABLED
}

enum {
	SNEAK,
	RUN,
	SPRINT
}

var state = MOVE
var gait = RUN
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

signal player_dies

func _ready():
	stats.connect("no_health", self, "kill")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
		DISABLED:
			pass

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/Sneak/blend_position", input_vector)
		animationTree.set("parameters/Sprint/blend_position", input_vector)
		animationState.travel(get_move_animation_state())
		velocity = velocity.move_toward(input_vector * get_max_speed(), get_acceleration() * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_pressed("sprint"):
		gait = SPRINT
	elif Input.is_action_pressed("sneak"):
		gait = SNEAK
	else:
		gait = RUN
		
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	velocity = move_and_slide(velocity)

func get_max_speed():
	match gait:
		SNEAK:
			return MAX_SPEED * 0.3
		RUN:
			return MAX_SPEED
		SPRINT:
			return MAX_SPEED * 2

func get_acceleration():
	match gait:
		SNEAK:
			return ACCELERATION
		RUN:
			return ACCELERATION
		SPRINT:
			return ACCELERATION * 2
	

func get_move_animation_state():
	match gait:
		SNEAK:
			return "Sneak"
		RUN:
			return "Run"
		SPRINT:
			return "Sprint"

func is_sneaking():
	return gait == SNEAK
	
func kill():
	emit_signal("player_dies")
	zoom_out_camera()
	queue_free()

func zoom_out_camera():
	return
	var main = get_tree().current_scene
	var camera = main.get_child(3)
	camera.get_child(0).interpolate_property(camera, "zoom", camera.zoom, camera.zoom + Vector2(0.5,0.5), 3, Tween.TRANS_LINEAR, Tween.EASE_OUT )
	camera.get_child(0).start()
	

func roll_animation_finished():
	velocity = velocity / 2
	state = MOVE
	
func attack_animation_finished():
	state = MOVE

func increase_health():
	stats.health += 1

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)


func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")


func _on_Goal_player_wins():
	animationState.travel("Idle")
	state = DISABLED
	zoom_out_camera()
