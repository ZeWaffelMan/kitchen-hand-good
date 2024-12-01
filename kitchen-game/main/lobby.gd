extends Node2D


@export var world: World
@export var level_manager: LevelManager

@export var story_player_detection: PlayerDetection
@export var battle_player_detection: PlayerDetection







func _process(delta: float) -> void:
	if story_player_detection.sees_player():
		if Input.is_action_just_pressed("left_click") or Input.is_joy_button_pressed(0, JOY_BUTTON_A):
			level_manager.switch_to_new_level(world.next_level, world.lobby_level, "lobby_to_counter")
	elif battle_player_detection.sees_player():
		var players = battle_player_detection.detected_areas
		if len(players) > 1:
			if Input.is_action_just_pressed("left_click") or Input.is_joy_button_pressed(0, JOY_BUTTON_A):
				level_manager.switch_to_new_level(world.battle_level, world.lobby_level, "lobby_to_arena")
