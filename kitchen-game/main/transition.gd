extends Node2D
class_name Transition


@export var world: World
@export var transition_animation_player: AnimationPlayer
@export var level_manager: LevelManager

@export var secret_box: StaticBody2D
@onready var secret_area_default_pos = secret_box.global_position

@onready var old_level: Level = level_manager.current_level


enum TransitionStates{
	WAIT,
	PULL_UP,
	RESET,
	PUT_AWAY
}

var transition_state = TransitionStates.WAIT


var new_level: Level

var is_transitioning: bool = false

var level_to_set: Level


func _process(delta: float) -> void:
	match transition_state:
		TransitionStates.WAIT:
			pass
		TransitionStates.PULL_UP:
			if !transition_animation_player.is_playing():
				transition_state = TransitionStates.RESET
		TransitionStates.RESET:
			# kill off remaining enemies if any
			var enemies = get_tree().get_nodes_in_group("enemy")
			for enemy in enemies:
				enemy.queue_free()
			
			# disable the old level
			old_level.hide()
			old_level.process_mode = PROCESS_MODE_DISABLED
			
			
			# set the new level
			level_manager.level_state = level_manager.LevelStates.WAIT
			level_to_set.process_mode = PROCESS_MODE_INHERIT
			level_to_set.show()
			new_level = level_to_set
			level_manager.current_level.reset_level()
			secret_box.global_position = secret_area_default_pos
			
			# bring back the player
			for player in world.players:
				player.health.health = player.health.max_health
				player.is_dead = false
				player.show()
				player.process_mode = PROCESS_MODE_ALWAYS
			
			transition_state = TransitionStates.PUT_AWAY
		TransitionStates.PUT_AWAY:
			transition_animation_player.play("transition_close")
			world.has_restarted = false
			is_transitioning = false
			transition_state = TransitionStates.WAIT



func transition_level(level: Level, old: Level, animation: String):
	old_level = old
	
	is_transitioning = true
	level_to_set = level
	transition_state = TransitionStates.PULL_UP
	transition_animation_player.play("transition_open")
