extends Node

var start_time

func start():
	start_time = OS.get_unix_time()

func get_elapsed_time():
	return OS.get_unix_time() - start_time
