extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")
const HealthPack = preload("res://Player/HealthPack.tscn")

export(String, "[None]", "HealthPack") var contents

func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)	
	grassEffect.global_position = global_position

func create_health_pack():
	var healthPack = HealthPack.instance()
	get_parent().add_child(healthPack)
	healthPack.global_position.x = global_position.x + 8
	healthPack.global_position.y = global_position.y + 8

func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	if contents == "HealthPack":
		create_health_pack()
	queue_free()
