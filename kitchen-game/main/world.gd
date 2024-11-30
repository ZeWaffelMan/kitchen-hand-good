extends Node2D
class_name World


@onready var level_manager: LevelManager = $LevelManager
@export var transition_animation_player: AnimationPlayer

@export var players: Array[Player]

@export var transition_controller: Transition
@export var lobby_level: Level

var has_restarted: bool = false


#func add_new_player(player_id, number, joined_with_mouse) -> void:
	#var new_player: Player = player.instantiate()
	#get_tree().current_scene.add_child(new_player)
	#
	#new_player.global_position = global_position
	#new_player.player_id = player_id
	#new_player.using_mouse = joined_with_mouse
	#new_player.player_number = number
	#


func _process(delta: float) -> void:
	var all_players_dead = true
	if players != null:
		for player in players:
			if not player.is_dead:
				all_players_dead = false
				break
		
		if all_players_dead and !has_restarted:
			level_manager.switch_to_new_level(lobby_level, level_manager.old_level, "to_lobby")
			all_players_dead = false
			has_restarted = true
