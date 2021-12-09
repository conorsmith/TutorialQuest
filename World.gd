extends Node2D

enum {
	PLAYING,
	PAUSED,
	GAME_OVER,
	WIN
}

var state = PLAYING

onready var birds = $YSort/Birds
onready var bats = $YSort/Bats
onready var boss = $YSort/Boss
onready var menus = $CanvasLayer/Menus

func _ready():
	$Stopwatch.start()
	
	$KillStats.set_max_birds(birds.get_child_count())
	$KillStats.set_max_bats(bats.get_child_count())
	
	for bird in birds.get_children():
		bird.connect("bird_dies", $KillStats, "increment_birds")
	for bat in bats.get_children():
		bat.connect("bat_dies", $KillStats, "increment_bats")

func reset_game():
	get_tree().reload_current_scene()
	PlayerStats._ready()

func quit_game():
	get_tree().change_scene("res://UI/TitleScreen.tscn")
	PlayerStats._ready()
	queue_free()

func pause_game():
	if state == PLAYING:
		state = PAUSED
		get_tree().paused = true
		menus.show_pause()
	
func resume_game():
	if state == PAUSED:
		state = PLAYING
		menus.hide_pause()
		get_tree().paused = false

func game_over():
	if state == PLAYING:
		state = GAME_OVER
		menus.show_game_over()

func win_game():
	if state == PLAYING:
		state = WIN
		menus.show_win($Stopwatch, $KillStats)
		kill_remaining_enemies()

func kill_remaining_enemies():
	if is_instance_valid(boss):
		boss.kill()
	for bat in bats.get_children():
		bat.kill()

func _on_Player_player_dies():
	game_over()

func _on_Goal_player_wins():
	win_game()

func _on_GameOver_Button_pressed():
	reset_game()

func _on_Win_Button_pressed():
	quit_game()

func _on_Pause_game_resumed():
	resume_game()

func _on_Pause_game_quit():
	resume_game()
	quit_game()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			pause_game()
