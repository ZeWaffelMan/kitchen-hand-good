extends Node2D
class_name Transition


@export var world: World
var new_level: Level
var player: Player


func _ready() -> void:
	player = world.player



func transition_level(level: Level, animation: String, is_dead: bool):
	var level_to_set: Level = level
	level.process_mode = PROCESS_MODE_INHERIT
	level.show()
	new_level = level_to_set
	
	if is_dead:
		var enemies = get_tree().get_nodes_in_group("enemy")
		for enemy in enemies:
			enemy.queue_free()
		player.health.health = player.health.max_health
		player.is_dead = false
		print("you died. go again!")
