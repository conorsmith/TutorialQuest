extends Node

func open_controls():
	hide_pause()
	show_controls()

func close_controls():
	hide_controls()
	show_pause()

func show_controls():
	$Controls.visible = true

func hide_controls():
	$Controls.visible = false

func show_pause():
	$Pause.visible = true

func hide_pause():
	$Pause.visible = false

func show_win(stopwatch, killStats):
	$Win.render_kill_stats(stopwatch, killStats)
	$Win.visible = true

func hide_win():
	$Win.visible = false

func show_game_over():
	$GameOver.visible = true

func hide_game_over():
	$GameOver.visible = false

func _on_Pause_open_controls():
	open_controls()

func _on_Controls_close_controls():
	close_controls()
