extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var rng = RandomNumberGenerator.new()

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 20

enum {
	IDLE,
	RUNNING,
	CAUTIOUS,
	LANDING
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var animationPlayer = $AnimationPlayer
onready var cautionTimer = $CautionTimer

signal bird_dies

func _ready():
	rng.randomize()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		
		IDLE:
			if playerDetectionZone.can_see_player():
				transition_from_idle_to_running()
		
		RUNNING:
			if !playerDetectionZone.can_see_player():
				transition_from_running_to_cautious()
				
		CAUTIOUS:
			if playerDetectionZone.can_see_player():
				transition_from_cautious_to_running()
		
		LANDING:
			if velocity.length() < FRICTION:
				transition_from_landing_to_idle()
	
	match state:
		
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
		RUNNING:
			var player = playerDetectionZone.player
			accelerate_away_from_point(player.global_position, delta)
			
		CAUTIOUS:
			pass
			
		LANDING:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)


func transition_from_idle_to_running():
	state = RUNNING
	sprite.animation = "Take Off"
	
func transition_from_running_to_cautious():
	cautionTimer.start()
	state = CAUTIOUS
	
func transition_from_cautious_to_running():
	state = RUNNING
	
func transition_from_cautious_to_landing():
	state = LANDING
	
func transition_from_landing_to_idle():
	state = IDLE
	sprite.animation = "Land"

func accelerate_away_from_point(point, delta):
	var direction = global_position.direction_to(point).normalized()
	direction = Vector2(-direction.x, -direction.y)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func kill():
	emit_signal("bird_dies")
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	
func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")

func _on_Stats_no_health():
	kill()

func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Stand":
		if rng.randi_range(1, 10) == 10:
			sprite.flip_h = !sprite.flip_h
	elif sprite.animation == "Take Off":
		sprite.animation = "Fly"
	elif sprite.animation == "Land":
		velocity = Vector2.ZERO
		sprite.animation = "Stand"


func _on_CautionTimer_timeout():
	transition_from_cautious_to_landing()
	transition_from_cautious_to_landing()
