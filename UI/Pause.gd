extends ColorRect

signal open_controls
signal game_resumed
signal game_quit

func _on_ResumeButton_pressed():
	emit_signal("game_resumed")

func _on_QuitButton_pressed():
	emit_signal("game_quit")

func _on_ControlsButton_pressed():
	emit_signal("open_controls")
