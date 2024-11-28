extends Node2D
class_name World


@onready var level_manager: LevelManager = $LevelManager
@export var transition_animation_player: AnimationPlayer
@export var transition: Transition
@export var lobby_level: Level

@export var player: Player


#func add_new_player(player_id, number, joined_with_mouse) -> void:
	#var new_player: Player = player.instantiate()
	#get_tree().current_scene.add_child(new_player)
	#
	#new_player.global_position = global_position
	#new_player.player_id = player_id
	#new_player.using_mouse = joined_with_mouse
	#new_player.player_number = number
	#


func start_over():
	#transition_animation_player.play("transition_close")
	transition.transition_level(lobby_level, "", true)
	level_manager.level_state = level_manager.LevelStates.NOT_ACTIVE


func check_if_player_dead() -> bool:
	if player.is_dead:
		return true
	else:
		return false
