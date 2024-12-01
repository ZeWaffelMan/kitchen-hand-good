extends Node2D

@export var world: World
@export var level_manager: LevelManager
@export var transition: Transition

@export var story_player_detection: PlayerDetection
@export var battle_player_detection: PlayerDetection

var has_transitioned = false


func _process(delta: float) -> void:
	if !has_transitioned:
		if story_player_detection.sees_player():
			level_manager.switch_to_new_level(world.next_level, world.lobby_level, "lobby_to_counter")
			has_transitioned = true
		elif battle_player_detection.sees_player():
			var players = battle_player_detection.detected_areas
			if len(players) > 1:
				level_manager.switch_to_new_level(world.battle_level, world.lobby_level, "lobby_to_arena")
				has_transitioned = true
	
	if transition.transition_state == transition.TransitionStates.RESET:
		has_transitioned = false
