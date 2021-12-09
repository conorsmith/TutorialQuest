extends Node

var birds = 0
var bats = 0
var max_birds
var max_bats

func set_max_birds(amount):
	max_birds = amount

func set_max_bats(amount):
	max_bats = amount

func increment_birds():
	birds += 1

func increment_bats():
	bats += 1
