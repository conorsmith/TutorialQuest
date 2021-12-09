extends ColorRect

signal close_controls

func _on_BackButton_pressed():
	emit_signal("close_controls")
