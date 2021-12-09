extends ColorRect

func render_kill_stats(stopwatch, killStats):
	var time = stopwatch.get_elapsed_time()
	if time < 10:
		$Heading.text = "\"Impossible!\""
	elif time < 30:
		$Heading.text = "\"That was fast\""
	elif time < 60:
		$Heading.text = "\"What took you so long?\""
	elif time < 120:
		$Heading.text = "\"Did you stop for lunch!?\""
	else:
		$Heading.text = "\"I assumed you died\""
	
	$Body.text = render_bats_killed(killStats.bats) + "\n" + render_birds_killed(killStats.birds)
	if (killStats.birds == killStats.max_birds):
		$Body.text += "\nYou monster!"
	elif (killStats.bats == killStats.max_bats):
		$Body.text += "\nRuthless efficiency"
	elif (killStats.birds == 0 and killStats.bats == 0):
		$Body.text += "\nBloodless coup"
	
func render_bats_killed(amount):
	var noun
	if amount == 1:
		noun = "bat"
	else:
		noun = "bats"
	return str(amount) + " " + noun + " killed"

func render_birds_killed(amount):
	var noun
	if amount == 1:
		noun = "bird"
	else:
		noun = "birds"
	return str(amount) + " " + noun + " killed"
